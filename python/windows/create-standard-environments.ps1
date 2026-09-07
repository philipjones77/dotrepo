param([string]$EnvironmentRoot = "$HOME\.virtualenvs")
$ErrorActionPreference = 'Stop'
$versions = [ordered]@{ py313 = '3.13.15'; py314 = '3.14.7'; py315 = '3.15.0rc2' }
foreach ($name in $versions.Keys) {
    $version = $versions[$name]
    $target = Join-Path $EnvironmentRoot $name
    if (Test-Path -LiteralPath $target) {
        throw "Environment already exists: $target. Review it before recreating."
    }
}
& uv python install @($versions.Values) --no-bin --system-certs
if ($LASTEXITCODE -ne 0) { throw 'CPython download failed.' }
foreach ($name in $versions.Keys) {
    $target = Join-Path $EnvironmentRoot $name
    & uv venv --managed-python --python $versions[$name] --seed --system-certs $target
    if ($LASTEXITCODE -ne 0) { throw "Creation failed: $name" }
    $python = Join-Path $target 'Scripts\python.exe'
    $packages = @('pip', 'wheel')
    if ($name -ne 'py315') { $packages += 'PyYAML' }
    if ($name -eq 'py313') { $packages += 'jax' }
    & $python -m pip install --upgrade @packages
    if ($LASTEXITCODE -ne 0) { throw "Package installation failed: $name" }
    & $python -m pip check
    if ($LASTEXITCODE -ne 0) { throw "Dependency check failed: $name" }
}
