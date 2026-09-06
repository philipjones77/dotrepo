param(
    [string]$Distribution = 'Ubuntu',
    [string]$LinuxRepoPath,
    [string]$OutputDirectory = (Join-Path $PSScriptRoot ('snapshots\' + (Get-Date -Format 'yyyyMMdd-HHmmss')))
)
$ErrorActionPreference = 'Stop'
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$OutputDirectory = (Resolve-Path -LiteralPath $OutputDirectory).Path
function Save-WslOutput([string]$Name, [string[]]$Arguments) {
    $result = & wsl.exe @Arguments 2>&1
    $code = $LASTEXITCODE
    (($result | Out-String) -replace "`0", '') | Set-Content -LiteralPath (Join-Path $OutputDirectory $Name) -Encoding UTF8
    if ($code -ne 0) { throw "WSL capture failed ($code): $Name. Partial report: $OutputDirectory" }
}
Save-WslOutput 'wsl-version.txt' @('--version')
Save-WslOutput 'wsl-status.txt' @('--status')
Save-WslOutput 'distributions.txt' @('--list', '--verbose')
Get-CimInstance Win32_OperatingSystem | Select-Object Caption,Version,TotalVisibleMemorySize,FreePhysicalMemory,LastBootUpTime |
    ConvertTo-Json | Set-Content (Join-Path $OutputDirectory 'windows.json') -Encoding UTF8
if (Test-Path -LiteralPath "$env:USERPROFILE\.wslconfig") {
    Copy-Item -LiteralPath "$env:USERPROFILE\.wslconfig" -Destination (Join-Path $OutputDirectory '.wslconfig')
} else {
    'No .wslconfig exists; WSL defaults apply.' | Set-Content (Join-Path $OutputDirectory 'wslconfig-defaults.txt')
}
$linuxPath = & wsl.exe -d $Distribution --exec wslpath -a -u $OutputDirectory.Replace('\', '/')
if ($LASTEXITCODE -ne 0) { throw 'Cannot resolve snapshot path inside WSL.' }
if (!$LinuxRepoPath) {
    $linuxHome = & wsl.exe -d $Distribution --exec printenv HOME
    if ($LASTEXITCODE -ne 0) { throw 'Cannot resolve WSL home.' }
    $LinuxRepoPath = $linuxHome.Trim() + '/projects/dotrepo'
}
$collectorPath = $LinuxRepoPath.TrimEnd('/') + '/wsl/capture-status.sh'
& wsl.exe -d $Distribution --exec test -f $collectorPath
if ($LASTEXITCODE -ne 0) { throw "Native collector is missing: $collectorPath. Update the WSL clone first." }
& wsl.exe -d $Distribution --exec bash $collectorPath.Trim() $linuxPath.Trim()
if ($LASTEXITCODE -ne 0) { throw "Linux capture failed. Partial report: $OutputDirectory" }
Save-WslOutput 'kernel-current.txt' @('-d', $Distribution, '-u', 'root', '--exec', 'journalctl', '-k', '-b', '--no-pager')
# Previous boot may be absent on a newly installed machine.
$previous = & wsl.exe -d $Distribution -u root --exec journalctl -k -b -1 --no-pager 2>&1
$previous | Set-Content (Join-Path $OutputDirectory 'kernel-previous.txt') -Encoding UTF8
Write-Host "Saved WSL snapshot: $OutputDirectory"
