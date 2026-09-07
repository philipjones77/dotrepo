$env:DOTREPO = Join-Path $HOME ".dotrepo"
if (!$env:PROJECTS_HOME) { $env:PROJECTS_HOME = 'C:\dev' }
Remove-Item Alias:R -ErrorAction SilentlyContinue

function Add-PathEntry {
    param([string]$Candidate)

    if (-not (Test-Path $Candidate)) {
        return
    }

    $parts = $env:Path -split ";"
    if ($parts -notcontains $Candidate) {
        $env:Path = "$Candidate;$env:Path"
    }
}

@(
    (Join-Path $HOME ".local\bin"),
    (Join-Path $HOME ".local\nodejs\current"),
    (Join-Path $HOME "bin"),
    (Join-Path $env:LOCALAPPDATA "Programs\Microsoft VS Code\bin"),
    (Join-Path $env:ProgramFiles "GitHub CLI")
) | ForEach-Object { Add-PathEntry $_ }
$rRoot = Join-Path $env:ProgramFiles 'R'
if (Test-Path $rRoot) {
    $rInstallation = Get-ChildItem -LiteralPath $rRoot -Directory |
        Where-Object Name -Match '^R-\d+\.\d+\.\d+$' |
        Sort-Object { [version]($_.Name -replace '^R-', '') } -Descending |
        Select-Object -First 1
    if ($rInstallation) { Add-PathEntry (Join-Path $rInstallation.FullName 'bin') }
}

if (Test-Path (Join-Path $HOME ".local\nodejs\current\node.exe")) {
    if (-not $env:NODE_USE_SYSTEM_CA) { $env:NODE_USE_SYSTEM_CA = "1" }
}

function ll { Get-ChildItem -Force }
function la { Get-ChildItem -Force }
function gs { git status -sb }
function croot { Set-Location -LiteralPath $env:PROJECTS_HOME }
function reload-profile { . $PROFILE }

function mkcd {
    param([Parameter(Mandatory = $true)][string]$Path)
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
    Set-Location $Path
}

function venv-win {
    param([string]$Path = ".venv")
    $standardPython = Join-Path $HOME '.virtualenvs\py313\Scripts\python.exe'
    if (Test-Path $standardPython) {
        & $standardPython -m venv $Path
        return
    }
    python -m venv $Path
}

$standardActivation = Join-Path $HOME '.virtualenvs\py313\Scripts\Activate.ps1'
if ((Test-Path $standardActivation) -and -not $env:VIRTUAL_ENV) {
    if (Get-Command conda -ErrorAction SilentlyContinue) {
        while ([int]$env:CONDA_SHLVL -gt 0) { conda deactivate }
    }
    . $standardActivation
} elseif (!(Test-Path $standardActivation) -and -not $env:VIRTUAL_ENV) {
    # Recovery targets may retain Conda while the shared source uses CPython.
    # Reuse an existing installation; never install or replace environments here.
    $existingConda = @('anaconda3', 'miniconda3') |
        ForEach-Object { Join-Path $HOME "$_\Scripts\conda.exe" } |
        Where-Object { Test-Path -LiteralPath $_ } |
        Select-Object -First 1
    if ($existingConda) {
        (& $existingConda 'shell.powershell' 'hook') | Out-String | Invoke-Expression
    }
}

if (Get-Command fnm -ErrorAction SilentlyContinue) {
    fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
}

$autoMountGoogleDrive = if ($env:DOTREPO_AUTO_MOUNT_GOOGLE_DRIVE) { $env:DOTREPO_AUTO_MOUNT_GOOGLE_DRIVE } else { "1" }
$googleDriveMountScript = Join-Path $env:DOTREPO "cloud\google-drive\mount-windows.ps1"
if ($autoMountGoogleDrive -eq "1" -and (Test-Path -LiteralPath $googleDriveMountScript)) {
    & $googleDriveMountScript -Quiet -NoWait
}

# Dotrepo: consistent paste keys for interactive PowerShell hosts.
if ($Host.Name -ne 'ServerRemoteHost' -and (Get-Module -ListAvailable PSReadLine)) {
    Import-Module PSReadLine
    Set-PSReadLineKeyHandler -Chord Ctrl+v,Ctrl+Shift+v,Shift+Insert -Function Paste
}
