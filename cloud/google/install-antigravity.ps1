param(
    [string]$InstallScript = "https://antigravity.google/cli/install.ps1"
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

Invoke-RestMethod $InstallScript | Invoke-Expression

$AgyPath = Join-Path $env:LOCALAPPDATA "agy\bin\agy.exe"
if (-not (Test-Path -LiteralPath $AgyPath)) {
    throw "Antigravity CLI was not found at $AgyPath after install"
}

& $AgyPath --version
