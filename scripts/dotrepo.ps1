param(
    [ValidateSet('validate','doctor','install','ssh','capture','drive','projects')][string]$Action = 'doctor',
    [ValidateSet('windows','wsl','all')][string]$Platform = 'windows',
    [string]$Distribution = 'Ubuntu',
    [string]$WslRepoPath,
    [ValidateSet('preserve','default','memory-32gb')][string]$WslProfile = 'preserve',
    [switch]$InstallTools,
    [switch]$Network
)
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path $PSScriptRoot -Parent
$pythonCommand = Join-Path $repoRoot '.venv-windows/Scripts/python.exe'
if (!(Test-Path -LiteralPath $pythonCommand)) { $pythonCommand = 'python' }
$failed = $false
foreach ($target in $(if ($Platform -eq 'all') { @('windows','wsl') } else { @($Platform) })) {
    Write-Host "[dotrepo] $Action on $target"
    $global:LASTEXITCODE = 0
    if ($target -eq 'windows') {
        switch ($Action) {
            validate { & $pythonCommand (Join-Path $PSScriptRoot 'validate.py') }
            doctor {
                $extra = @(); if ($Network) { $extra += '--network' }
                & $pythonCommand (Join-Path $PSScriptRoot 'doctor.py') --platform windows @extra
            }
            install { & (Join-Path $repoRoot 'bootstrap/install.ps1') -WslProfile $WslProfile -InstallTools:$InstallTools }
            ssh { & (Join-Path $repoRoot 'ssh/setup.ps1') }
            drive { & (Join-Path $repoRoot 'windows/google-drive.ps1') -Install:$InstallTools }
            projects { & $pythonCommand (Join-Path $PSScriptRoot 'projects.py') --root C:/dev }
            capture {
                $out = Join-Path $repoRoot ('reports/windows-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.json')
                New-Item -ItemType Directory -Path (Split-Path $out) -Force | Out-Null
                & $pythonCommand (Join-Path $PSScriptRoot 'doctor.py') --platform windows --json | Set-Content $out -Encoding UTF8
                Write-Host "Saved $out"
            }
        }
    } else {
        if ($Action -eq 'capture') {
            & (Join-Path $repoRoot 'wsl/capture-status.ps1') -Distribution $Distribution -LinuxRepoPath $WslRepoPath
        } else {
            $linuxRoot = $WslRepoPath
            if (!$linuxRoot) {
                $linuxHome = & wsl.exe -d $Distribution --exec printenv HOME
                if ($LASTEXITCODE -ne 0) { throw 'Cannot resolve the WSL user home.' }
                $linuxRoot = $linuxHome.Trim() + '/projects/dotrepo'
            }
            & wsl.exe -d $Distribution --exec test -f "$linuxRoot/scripts/dotrepo.sh"
            if ($LASTEXITCODE -ne 0) { throw "Native WSL management checkout is missing or outdated: $linuxRoot. Clone/update dotrepo there, or pass -WslRepoPath explicitly." }
            $extra = @()
            if ($Action -eq 'doctor' -and $Network) { $extra += '--network' }
            if ($Action -eq 'install' -and $InstallTools) { $extra += '--install-tools' }
            & wsl.exe -d $Distribution --exec bash "$linuxRoot/scripts/dotrepo.sh" $Action @extra
        }
    }
    if ($LASTEXITCODE -ne 0) { $failed = $true }
}
if ($failed) { throw 'One or more platform checks failed; see output above.' }
