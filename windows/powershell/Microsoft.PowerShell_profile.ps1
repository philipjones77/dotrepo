$env:DOTREPO = Join-Path $HOME ".dotrepo"

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
    (Join-Path $HOME "bin"),
    (Join-Path $env:LOCALAPPDATA "Programs\Microsoft VS Code\bin"),
    (Join-Path $HOME "anaconda3\Scripts"),
    (Join-Path $HOME "anaconda3\condabin")
) | ForEach-Object { Add-PathEntry $_ }

function ll { Get-ChildItem -Force }
function la { Get-ChildItem -Force }
function gs { git status -sb }
function reload-profile { . $PROFILE }

function mkcd {
    param([Parameter(Mandatory = $true)][string]$Path)
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
    Set-Location $Path
}

function venv-win {
    param([string]$Path = ".venv")
    $pythonExe = Join-Path $HOME "anaconda3\python.exe"
    if (Test-Path $pythonExe) {
        & $pythonExe -m venv $Path
        return
    }

    python -m venv $Path
}

$condaExe = Join-Path $HOME "anaconda3\Scripts\conda.exe"
if (Test-Path $condaExe) {
    (& $condaExe "shell.powershell" "hook") | Out-String | Invoke-Expression
    conda activate base
}

if (Get-Command fnm -ErrorAction SilentlyContinue) {
    fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
}

Set-Location $HOME
