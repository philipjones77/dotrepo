param([string]$EnvironmentRoot = "$HOME\.virtualenvs")
$ErrorActionPreference = 'Stop'
$target = Join-Path $EnvironmentRoot 'py314'
if (Test-Path -LiteralPath $target) {
    throw "Environment already exists: $target. Review it before recreating."
}
$savedCertFile = $env:SSL_CERT_FILE
$savedCertDir = $env:SSL_CERT_DIR
try {
    $env:SSL_CERT_FILE = $null
    $env:SSL_CERT_DIR = $null
    & uv python install 3.14.10 --no-bin --system-certs
    if ($LASTEXITCODE -ne 0) { throw 'CPython download failed.' }
    & uv venv --managed-python --python 3.14.10 --seed --prompt py314 --system-certs $target
    if ($LASTEXITCODE -ne 0) { throw 'Creation failed: py314' }
    $python = Join-Path $target 'Scripts\python.exe'
    & uv pip sync --python $python --system-certs (Join-Path $PSScriptRoot 'requirements-py314.txt')
    if ($LASTEXITCODE -ne 0) { throw 'Package installation failed: py314' }
    & uv pip check --python $python
    if ($LASTEXITCODE -ne 0) { throw 'Dependency check failed: py314' }
} finally {
    $env:SSL_CERT_FILE = $savedCertFile
    $env:SSL_CERT_DIR = $savedCertDir
}
