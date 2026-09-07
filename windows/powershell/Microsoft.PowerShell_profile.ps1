$env:DOTREPO = Join-Path $HOME ".dotrepo"
if (!$env:PROJECTS_HOME) { $env:PROJECTS_HOME = 'C:\dev' }
Remove-Item Alias:R -ErrorAction SilentlyContinue

$script:dotrepoCondaRoot = @('anaconda3', 'miniconda3') |
    ForEach-Object { Join-Path $HOME $_ } |
    Where-Object { Test-Path (Join-Path $_ 'Scripts\conda.exe') } |
    Select-Object -First 1

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
if ($script:dotrepoCondaRoot) {
    Add-PathEntry (Join-Path $script:dotrepoCondaRoot 'Scripts')
    Add-PathEntry (Join-Path $script:dotrepoCondaRoot 'condabin')
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
    if ($script:dotrepoCondaRoot) {
        $pythonExe = Join-Path $script:dotrepoCondaRoot 'python.exe'
        & $pythonExe -m venv $Path
        return
    }

    python -m venv $Path
}

if ($script:dotrepoCondaRoot) {
    $condaExe = Join-Path $script:dotrepoCondaRoot 'Scripts\conda.exe'
    (& $condaExe "shell.powershell" "hook") | Out-String | Invoke-Expression
    conda activate base
}

if (Get-Command fnm -ErrorAction SilentlyContinue) {
    fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
}

$autoMountGoogleDrive = if ($env:DOTREPO_AUTO_MOUNT_GOOGLE_DRIVE) { $env:DOTREPO_AUTO_MOUNT_GOOGLE_DRIVE } else { "1" }
$googleDriveMountScript = Join-Path $env:DOTREPO "cloud\google-drive\mount-windows.ps1"
if ($autoMountGoogleDrive -eq "1" -and (Test-Path -LiteralPath $googleDriveMountScript)) {
    & $googleDriveMountScript -Quiet -NoWait
}
