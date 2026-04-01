param(
    [string]$Path = "$HOME\.virtualenvs\jax-win",
    [string]$PythonExe = "$HOME\anaconda3\python.exe"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $PythonExe)) {
    $PythonExe = (Get-Command python -ErrorAction Stop).Source
}

& $PythonExe -m venv $Path

$VenvPython = Join-Path $Path "Scripts\python.exe"
& $VenvPython -m pip install --upgrade pip wheel
& $VenvPython -m pip install -r (Join-Path $PSScriptRoot "requirements.txt")

Write-Host "[dotrepo] Created $Path and installed python/windows/requirements.txt"
