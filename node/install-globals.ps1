$ErrorActionPreference = "Stop"

$PackagesFile = Join-Path $PSScriptRoot "global-packages.txt"

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host "[dotrepo] npm not found; skipping global package install"
    exit 0
}

$Packages = Get-Content $PackagesFile | Where-Object {
    $line = $_.Trim()
    $line -and -not $line.StartsWith("#")
}

if (-not $Packages) {
    Write-Host "[dotrepo] No tracked global npm packages to install"
    exit 0
}

& npm install -g $Packages
