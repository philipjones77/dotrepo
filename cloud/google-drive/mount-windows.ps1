param(
    [switch]$Quiet,
    [switch]$NoWait,
    [ValidateRange(0, 3600)]
    [int]$TimeoutSeconds = 30
)

$ErrorActionPreference = 'Stop'
$DriveLetter = if ($env:DOTREPO_GDRIVE_WINDOWS_DRIVE) { $env:DOTREPO_GDRIVE_WINDOWS_DRIVE } else { 'G' }
$DriveRoot = "${DriveLetter}:\"

function Write-Log {
    param([string]$Message)
    if (-not $Quiet) { Write-Host "[dotrepo-google-drive] $Message" }
}

function Test-GoogleDriveMounted {
    # String construction also works before this drive letter exists.
    return (Test-Path -LiteralPath "${DriveRoot}My Drive")
}

if (Test-GoogleDriveMounted) {
    Write-Log "Windows Google Drive is mounted at $DriveRoot"
    exit 0
}

# The canonical helper owns executable discovery, login startup and launching
# with the desktop application's normal certificate environment.
$RepoRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$CanonicalScript = Join-Path $RepoRoot 'windows\google-drive.ps1'
if ($Quiet) {
    & $CanonicalScript 1>$null 6>$null
}
else {
    & $CanonicalScript
}

if ($NoWait) { exit 0 }
$deadline = (Get-Date).AddSeconds($TimeoutSeconds)
while ((Get-Date) -lt $deadline) {
    if (Test-GoogleDriveMounted) {
        Write-Log "Windows Google Drive mounted at $DriveRoot"
        exit 0
    }
    Start-Sleep -Seconds 1
}
Write-Log "Timed out waiting for Google Drive at $DriveRoot"
exit 0
