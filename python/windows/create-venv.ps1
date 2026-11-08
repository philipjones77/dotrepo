param(
    [string]$Path = ".venv-py314",
    [string]$PythonExe = "$HOME\.virtualenvs\py314\Scripts\python.exe"
)

$ErrorActionPreference = "Stop"

if (Test-Path -LiteralPath $Path) { throw "Environment already exists: $Path" }
if (-not (Test-Path -LiteralPath $PythonExe)) { throw 'Install the standard py314 environment first.' }
$version = & $PythonExe -c 'import sys; print("%d.%d" % sys.version_info[:2])'
if ($LASTEXITCODE -ne 0 -or $version -ne '3.14') { throw 'Python 3.14 is required.' }

& $PythonExe -m venv $Path
if ($LASTEXITCODE -ne 0) { throw 'Virtual environment creation failed.' }

$VenvPython = Join-Path $Path "Scripts\python.exe"
$savedCertFile = $env:SSL_CERT_FILE
$savedCertDir = $env:SSL_CERT_DIR
try {
    $env:SSL_CERT_FILE = $null
    $env:SSL_CERT_DIR = $null
    & uv pip install --python $VenvPython --system-certs -r (Join-Path $PSScriptRoot "requirements-py314.txt")
    if ($LASTEXITCODE -ne 0) { throw 'Python requirements installation failed.' }
} finally {
    $env:SSL_CERT_FILE = $savedCertFile
    $env:SSL_CERT_DIR = $savedCertDir
}
& uv pip check --python $VenvPython
if ($LASTEXITCODE -ne 0) { throw 'Python dependency check failed.' }

Write-Host "[dotrepo] Created $Path with the Windows Python 3.14 toolchain."
