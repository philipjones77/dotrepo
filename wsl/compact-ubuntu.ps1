# Run in an Administrator PowerShell after saving Linux work.
# Stops all WSL distributions to detach Ubuntu's disk for compaction.
param([string]$Distribution = 'Ubuntu')
$ErrorActionPreference = 'Stop'
$principal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (!$principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'DiskPart compaction requires an Administrator PowerShell.'
}
$distros = @(Get-ChildItem HKCU:\Software\Microsoft\Windows\CurrentVersion\Lxss |
    Get-ItemProperty | Where-Object DistributionName -eq $Distribution)
if ($distros.Count -ne 1) { throw 'Expected exactly one matching WSL distribution.' }
$disk = (Resolve-Path -LiteralPath (Join-Path $distros[0].BasePath 'ext4.vhdx')).Path
if ($disk.Contains('"') -or $disk.Contains("`n")) { throw 'Invalid disk path.' }
$reportDir = Join-Path $PSScriptRoot 'snapshots'
New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
$log = Join-Path $reportDir ('compaction-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.txt')
$before = (Get-Item -LiteralPath $disk).Length
& wsl.exe --shutdown
if ($LASTEXITCODE -ne 0) { throw 'WSL shutdown failed.' }
$commands = Join-Path $reportDir 'compact-diskpart.txt'
@("select vdisk file=`"$disk`"", 'compact vdisk', 'exit') | Set-Content -LiteralPath $commands -Encoding ASCII
& diskpart.exe /s $commands | Tee-Object -FilePath $log
$diskpartCode = $LASTEXITCODE
$after = (Get-Item -LiteralPath $disk).Length
"DiskPart exit: $diskpartCode; Before bytes: $before; After bytes: $after; Reclaimed bytes: $($before - $after)" |
    Tee-Object -FilePath $log -Append
if ($diskpartCode -ne 0) { throw "DiskPart failed; see $log" }
Write-Host "Review DiskPart completion in $log"
