param([switch]$Install, [switch]$QuietIfMissing)
$ErrorActionPreference = 'Stop'
if ($Install) {
    $winget = Get-Command winget -ErrorAction SilentlyContinue
    $wingetPath = if ($winget) { $winget.Source } else { Join-Path $env:LOCALAPPDATA 'Microsoft\WindowsApps\winget.exe' }
    if (!(Test-Path -LiteralPath $wingetPath)) { throw 'Install Microsoft App Installer (winget) first.' }
    & $wingetPath install --id Google.GoogleDrive --exact --source winget --accept-source-agreements --accept-package-agreements --silent --disable-interactivity
    if ($LASTEXITCODE -ne 0) { throw 'Google Drive installation failed; inspect winget output.' }
}
$roots = @((Join-Path $env:ProgramFiles 'Google\Drive File Stream'), (Join-Path $env:LOCALAPPDATA 'Google\Drive File Stream'))
$exe = $roots | Where-Object { Test-Path -LiteralPath $_ } | ForEach-Object {
    Get-ChildItem -LiteralPath $_ -Filter GoogleDriveFS.exe -Recurse -ErrorAction SilentlyContinue
} | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (!$exe) {
    if ($QuietIfMissing) { return }
    throw 'Google Drive desktop is missing. Run with -Install.'
}
if (!(Test-Path 'HKCU:\Software\Google\DriveFS')) {
    New-Item -Path 'HKCU:\Software\Google\DriveFS' | Out-Null
}
New-ItemProperty -Path 'HKCU:\Software\Google\DriveFS' -Name AutoStartOnLogin -PropertyType DWord -Value 1 -Force | Out-Null
if (!(Get-Process GoogleDriveFS -ErrorAction SilentlyContinue)) {
    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = $exe.FullName
    $startInfo.UseShellExecute = $false
    $startInfo.CreateNoWindow = $true
    $startInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
    # Conda's CA bundle can fail Schannel chain building in desktop apps.
    # Use Drive's normal certificate trust without changing the caller's env.
    if ($env:__CONDA_OPENSSL_CERT_FILE_SET) {
        $startInfo.EnvironmentVariables.Remove('SSL_CERT_FILE')
        $startInfo.EnvironmentVariables.Remove('__CONDA_OPENSSL_CERT_FILE_SET')
    }
    [System.Diagnostics.Process]::Start($startInfo) | Out-Null
}
Write-Host "Google Drive desktop: $($exe.FullName)"
Write-Host 'Automatic launch at Windows login is enabled. Sign in once to mount your Drive.'
Write-Host 'WSL uses its independently authenticated rclone mount at ~/mnt/gdrive; access mode is configured separately.'
