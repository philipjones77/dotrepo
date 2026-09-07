[CmdletBinding()]
param(
    [ValidateSet('Start', 'Serve', 'EnableAtLogon', 'DisableAtLogon', 'Status', 'Stop')]
    [string]$Action = 'Start',
    [ValidatePattern('^[A-Za-z0-9_.-]+$')][string]$Distribution = 'Ubuntu',
    [ValidatePattern('^[A-Za-z0-9_.-]+$')][string]$LinuxUser = $env:USERNAME
)
$ErrorActionPreference = 'Stop'
$wsl = Join-Path $env:SystemRoot 'System32\wsl.exe'
$powershell = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
$scriptPath = $PSCommandPath
$runKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run'
$runName = "DotrepoWslGoogleDrive-$Distribution-$LinuxUser"
$logDir = Join-Path $env:LOCALAPPDATA 'dotrepo\logs'
$logPath = Join-Path $logDir 'wsl-google-drive.log'

function Save-RunEntry {
    $current = Get-ItemProperty -LiteralPath $runKey -Name $runName -ErrorAction SilentlyContinue
    $keyItem = Get-Item -LiteralPath $runKey -ErrorAction SilentlyContinue
    $allValues = if ($keyItem) {
        @($keyItem.GetValueNames() | ForEach-Object {
            [ordered]@{
                Name = $_
                Kind = $keyItem.GetValueKind($_).ToString()
                Value = $keyItem.GetValue($_, $null, [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames)
            }
        })
    } else { @() }
    $backupDir = Join-Path $env:USERPROFILE ('.dotrepo-backups\{0}-wsl-google-drive' -f (Get-Date -Format 'yyyyMMdd-HHmmss-fff'))
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    [ordered]@{
        Key = $runKey; Name = $runName
        Present = $null -ne $current
        Value = if ($current) { $current.$runName } else { $null }
        AllValues = $allValues
    } | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $backupDir 'run-entry.json') -Encoding UTF8
    return $backupDir
}

function Start-DriveAnchor {
    # Windows filenames cannot contain quotes; distro/user names are restricted above.
    $arguments = '-NoLogo -NoProfile -WindowStyle Hidden -File "{0}" -Action Serve -Distribution {1} -LinuxUser {2}' -f $scriptPath, $Distribution, $LinuxUser
    Start-Process -FilePath $powershell -ArgumentList $arguments -WindowStyle Hidden | Out-Null
}

if ($Action -eq 'EnableAtLogon') {
    $backup = Save-RunEntry
    if (!(Test-Path -LiteralPath $runKey)) {
        New-Item -Path $runKey | Out-Null
    }
    $value = '"{0}" -NoLogo -NoProfile -WindowStyle Hidden -File "{1}" -Action Serve -Distribution {2} -LinuxUser {3}' -f $powershell, $scriptPath, $Distribution, $LinuxUser
    New-ItemProperty -LiteralPath $runKey -Name $runName -PropertyType String -Value $value -Force | Out-Null
    Start-DriveAnchor
    Write-Output "Enabled the $Distribution Drive mount at Windows login. Backup: $backup"
    return
}
if ($Action -eq 'DisableAtLogon') {
    $backup = Save-RunEntry
    Remove-ItemProperty -LiteralPath $runKey -Name $runName -ErrorAction SilentlyContinue
    Write-Output "Disabled the login anchor. Backup: $backup"
    return
}
if ($Action -eq 'Start') {
    Start-DriveAnchor
    Write-Output "Requested the $Distribution Drive mount. Log: $logPath"
    return
}

$mutex = $null
$ownsMutex = $false
try {
    if ($Action -in @('Serve', 'Stop')) {
        $sid = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
        $mutex = New-Object System.Threading.Mutex($false, "Local\DotrepoWslGoogleDrive-$sid-$Distribution-$LinuxUser")
    }
    if ($Action -eq 'Serve') {
        try { $ownsMutex = $mutex.WaitOne(0) }
        catch [System.Threading.AbandonedMutexException] { $ownsMutex = $true }
        if (!$ownsMutex) { return }
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
        "$(Get-Date -Format o) Starting $Distribution Drive anchor." | Add-Content -LiteralPath $logPath -Encoding UTF8
    }
    $linuxHome = (& $wsl --distribution $Distribution --user $LinuxUser --exec /usr/bin/printenv HOME | Out-String).Trim()
    if ($LASTEXITCODE -ne 0 -or !$linuxHome.StartsWith('/') -or $linuxHome.Contains("`n")) {
        throw "Could not determine the home directory for $LinuxUser in $Distribution."
    }
    $mountScript = "$linuxHome/.dotrepo/wsl/mounts/gdrive.sh"
    if ($Action -eq 'Serve') {
        # A live wsl.exe command keeps the VM available after terminals close.
        # The Linux helper owns credentials, mode, cache limits and mount locking.
        & $wsl --distribution $Distribution --user $LinuxUser --exec /bin/bash $mountScript serve 2>&1 |
            ForEach-Object { $_.ToString() | Add-Content -LiteralPath $logPath -Encoding UTF8 }
    } else {
        & $wsl --distribution $Distribution --user $LinuxUser --exec /bin/bash $mountScript $Action.ToLowerInvariant()
    }
    if ($LASTEXITCODE -ne 0) { throw "The Drive helper exited with code $LASTEXITCODE. See $logPath." }
    if ($Action -eq 'Stop') {
        # Linux unmounts before its sleeping Serve loop exits. Wait for that
        # anchor to release the mutex so an immediate Start is not discarded.
        try { $ownsMutex = $mutex.WaitOne(45000) }
        catch [System.Threading.AbandonedMutexException] { $ownsMutex = $true }
        if (!$ownsMutex) {
            throw "Drive was unmounted, but the previous $Distribution anchor did not exit within 45 seconds. See $logPath."
        }
    }
} catch {
    if ($Action -eq 'Serve') {
        "$(Get-Date -Format o) $($_.Exception.Message)" | Add-Content -LiteralPath $logPath -Encoding UTF8
    }
    throw
} finally {
    if ($ownsMutex) { $mutex.ReleaseMutex() }
    if ($mutex) { $mutex.Dispose() }
}
