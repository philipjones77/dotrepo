param(
    [string]$NodeVersion,
    [string]$Package = "@google/gemini-cli@latest"
)

$ErrorActionPreference = "Stop"

if (-not $NodeVersion) {
    $RepoRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    $NodeVersion = 'v' + (Get-Content -Raw -LiteralPath (Join-Path $RepoRoot 'node\.node-version')).Trim()
}
if ($NodeVersion -notmatch '^v\d+\.\d+\.\d+$') {
    throw 'NodeVersion must be an explicit version such as v24.20.0.'
}

$InstallRoot = Join-Path $HOME ".local\nodejs"
$ZipPath = Join-Path $InstallRoot "node-$NodeVersion-win-x64.zip"
$ExtractPath = Join-Path $InstallRoot "node-$NodeVersion-win-x64"
$CurrentPath = Join-Path $InstallRoot "current"

New-Item -ItemType Directory -Path $InstallRoot -Force | Out-Null

if (-not (Test-Path -LiteralPath $ZipPath)) {
    Invoke-WebRequest -Uri "https://nodejs.org/dist/$NodeVersion/node-$NodeVersion-win-x64.zip" -OutFile $ZipPath
}

$Checksums = (Invoke-WebRequest -Uri "https://nodejs.org/dist/$NodeVersion/SHASUMS256.txt").Content
$ArchiveName = "node-$NodeVersion-win-x64.zip"
$ChecksumPattern = '(?m)^([a-fA-F0-9]{64})\s+\*?' + [regex]::Escape($ArchiveName) + '\r?$'
$ChecksumMatches = [regex]::Matches($Checksums, $ChecksumPattern)
if ($ChecksumMatches.Count -ne 1 -or
    (Get-FileHash -LiteralPath $ZipPath -Algorithm SHA256).Hash -ine $ChecksumMatches[0].Groups[1].Value) {
    throw "Official SHA-256 verification failed for $ArchiveName; no runtime was changed."
}

# Always use newly extracted verified bytes; retain any previous installation.
$Stamp = Get-Date -Format 'yyyyMMdd-HHmmss-fff'
$StageRoot = Join-Path $InstallRoot "staged-$Stamp"
Expand-Archive -LiteralPath $ZipPath -DestinationPath $StageRoot
$StagedRuntime = Join-Path $StageRoot "node-$NodeVersion-win-x64"
if (-not (Test-Path -LiteralPath (Join-Path $StagedRuntime 'node.exe'))) {
    throw 'Verified archive did not contain the expected Node executable.'
}
$ResolvedRoot = (Resolve-Path -LiteralPath $InstallRoot).Path.TrimEnd('\') + '\'
foreach ($movePath in @($ExtractPath, $StagedRuntime, $CurrentPath)) {
    if (-not [IO.Path]::GetFullPath($movePath).StartsWith($ResolvedRoot, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Runtime path escapes the intended install root: $movePath"
    }
}
if (Test-Path -LiteralPath $ExtractPath) {
    Move-Item -LiteralPath $ExtractPath -Destination (Join-Path $InstallRoot "node-$NodeVersion-win-x64-before-$Stamp")
}
Move-Item -LiteralPath $StagedRuntime -Destination $ExtractPath
Remove-Item -LiteralPath $StageRoot

if (Test-Path -LiteralPath $CurrentPath) {
    $item = Get-Item -LiteralPath $CurrentPath -Force
    if ($item.LinkType) {
        Remove-Item -LiteralPath $CurrentPath -Force
    }
    elseif ($item.FullName -ne $ExtractPath) {
        Rename-Item -LiteralPath $CurrentPath -NewName ("previous-" + (Get-Date -Format "yyyyMMdd-HHmmss"))
    }
}

if (-not (Test-Path -LiteralPath $CurrentPath)) {
    New-Item -ItemType Junction -Path $CurrentPath -Target $ExtractPath | Out-Null
}

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$pathParts = @()
if ($userPath) {
    $pathParts = $userPath -split ";" | Where-Object { $_ }
}
if ($pathParts -notcontains $CurrentPath) {
    [Environment]::SetEnvironmentVariable("Path", ((@($CurrentPath) + $pathParts) -join ";"), "User")
}
[Environment]::SetEnvironmentVariable("NODE_USE_SYSTEM_CA", "1", "User")

$env:Path = "$CurrentPath;$env:Path"
$env:NODE_USE_SYSTEM_CA = "1"

& (Join-Path $CurrentPath 'node.exe') --version
if ($LASTEXITCODE -ne 0) { throw 'Node verification failed.' }
& (Join-Path $CurrentPath 'npm.cmd') --version
if ($LASTEXITCODE -ne 0) { throw 'npm verification failed.' }
& (Join-Path $CurrentPath 'npm.cmd') install -g --engine-strict --allow-scripts=@github/keytar,node-pty $Package
if ($LASTEXITCODE -ne 0) { throw 'Gemini installation failed.' }
& gemini --version
if ($LASTEXITCODE -ne 0) { throw 'Gemini verification failed.' }
