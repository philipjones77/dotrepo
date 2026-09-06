$ErrorActionPreference = "Stop"

$DriveLetter = if ($env:DOTREPO_GDRIVE_WINDOWS_DRIVE) { $env:DOTREPO_GDRIVE_WINDOWS_DRIVE } else { "G" }
$DriveRoot = "${DriveLetter}:\"

function Write-Check {
    param([string]$Name, [string]$Status, [string]$Detail = "")
    "| google-drive | $Name | $Status | $Detail |"
}

"# Google Drive Audit"
""
"Generated: $(Get-Date -Format s)"
""
"| Area | Check | Status | Detail |"
"| --- | --- | --- | --- |"

$drive = Get-PSDrive -Name $DriveLetter -PSProvider FileSystem -ErrorAction SilentlyContinue
if ($drive) {
    Write-Check "Windows drive ${DriveLetter}:" "ok" $drive.Description
}
else {
    Write-Check "Windows drive ${DriveLetter}:" "missing" "Google Drive for desktop is not mounted at ${DriveRoot}"
}

if (Test-Path -LiteralPath $DriveRoot) {
    $expected = Join-Path $DriveRoot "My Drive"
    if (Test-Path -LiteralPath $expected) {
        Write-Check "My Drive" "ok" $expected
    }
    else {
        Write-Check "My Drive" "manual-check" "Drive exists, but My Drive was not found"
    }
}

$process = Get-Process -Name "GoogleDriveFS" -ErrorAction SilentlyContinue | Select-Object -First 1
if ($process) {
    Write-Check "Google Drive process" "ok" "pid $($process.Id)"
}
else {
    Write-Check "Google Drive process" "manual-check" "Process not found; Drive may still be mounted by another process name"
}

if (Get-Command wsl -ErrorAction SilentlyContinue) {
    try {
        $wslPath = "/mnt/$($DriveLetter.ToLowerInvariant())"
        $result = & wsl.exe -d Ubuntu -- bash -lc "mountpoint -q '$wslPath' && echo mounted || echo missing" 2>$null
        if (($result | Select-Object -First 1) -eq "mounted") {
            Write-Check "WSL DrvFs $wslPath" "ok" "Ubuntu"
        }
        else {
            Write-Check "WSL DrvFs $wslPath" "missing" "Ubuntu does not see ${DriveLetter}: at $wslPath"
        }
    }
    catch {
        Write-Check "WSL DrvFs" "manual-check" "Unable to query Ubuntu"
    }
}
else {
    Write-Check "WSL DrvFs" "not-applicable" "wsl.exe not found"
}
