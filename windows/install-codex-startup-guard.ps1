param(
    [string]$CodeCommand = 'code',
    [string]$Distro = 'Ubuntu',
    [switch]$SkipWsl
)
# Install the Codex startup guard into Windows VS Code and the WSL VS Code server.
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$source = Join-Path $repoRoot 'vscode\codex-startup-guard'
$version = (Get-Content -LiteralPath (Join-Path $source 'package.json') -Raw | ConvertFrom-Json).version
$package = Join-Path $repoRoot ".local\codex-startup-guard-$version.vsix"

& node (Join-Path $source 'test-timeouts.cjs')
if ($LASTEXITCODE -ne 0) { throw 'Codex startup guard tests failed.' }
& python (Join-Path $source 'package.py') $package
if ($LASTEXITCODE -ne 0) { throw 'Could not package the Codex startup guard.' }

& $CodeCommand --install-extension $package --force
if ($LASTEXITCODE -ne 0) { throw 'Could not install the Codex startup guard into Windows VS Code.' }

if (-not $SkipWsl) {
    $wslPackage = (& wsl.exe -d $Distro -- wslpath -a ($package -replace '\\', '/')).Trim()
    # Any installed server CLI writes to the shared ~/.vscode-server/extensions folder.
    $install = 'server=$(ls -dt ~/.vscode-server/bin/*/bin/code-server 2>/dev/null | head -1); ' +
        'if [ -z "$server" ]; then echo "No VS Code server in WSL; open a WSL window once, then rerun." >&2; exit 2; fi; ' +
        '"$server" --install-extension "$1" --force'
    # --exec passes arguments verbatim; without it wsl.exe re-splits the script through a shell.
    & wsl.exe -d $Distro --exec sh -c $install sh $wslPackage
    if ($LASTEXITCODE -ne 0) { throw "Could not install the Codex startup guard into the $Distro VS Code server." }
}
Write-Output "Codex startup guard $version installed. Reload open VS Code windows to activate it."
