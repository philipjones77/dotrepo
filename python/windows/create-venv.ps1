param(
    [string]$Path = "$HOME\.virtualenvs\jax-win",
    [string]$PythonExe = "$HOME\anaconda3\python.exe"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $PythonExe)) {
    $PythonExe = (Get-Command python -ErrorAction Stop).Source
}

& $PythonExe -m venv $Path
if ($LASTEXITCODE -ne 0) { throw 'Virtual environment creation failed.' }

$VenvPython = Join-Path $Path "Scripts\python.exe"
& $VenvPython -m pip install --upgrade pip wheel
if ($LASTEXITCODE -ne 0) { throw 'pip bootstrap failed.' }
& $VenvPython -m pip install -r (Join-Path $PSScriptRoot "requirements.txt")
if ($LASTEXITCODE -ne 0) { throw 'Python requirements installation failed.' }

Write-Host "[dotrepo] Created $Path and installed python/windows/requirements.txt"
