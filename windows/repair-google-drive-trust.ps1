# Run elevated. Adds only an explicitly selected, already trusted local root.
# https://knowledge.workspace.google.com/admin/drive/advanced-drive-for-desktop-configuration
param([Parameter(Mandatory = $true)][ValidatePattern('^[A-Fa-f0-9]{40}$')][string]$RootThumbprint)
$ErrorActionPreference = 'Stop'
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
if (!([Security.Principal.WindowsPrincipal]$identity).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'Run this script from an administrator PowerShell.'
}
$cert = Get-ChildItem Cert:\LocalMachine\Root | Where-Object Thumbprint -EQ $RootThumbprint | Select-Object -First 1
if (!$cert) { throw 'The selected certificate is not in the machine trusted root store.' }
if ($cert.NotAfter -le (Get-Date) -or $cert.NotBefore -gt (Get-Date)) { throw 'The selected certificate is outside its validity period.' }
$exe = Get-ChildItem "$env:ProgramFiles\Google\Drive File Stream" -Filter GoogleDriveFS.exe -Recurse |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (!$exe) { throw 'Google Drive desktop is not installed.' }
$googleRoots = Join-Path $exe.DirectoryName 'config\roots.pem'
if (!(Test-Path -LiteralPath $googleRoots)) { throw 'Google Drive bundled certificates are missing.' }
$directory = Join-Path $env:ProgramData 'dotrepo\google-drive-trust'
New-Item -ItemType Directory -Path $directory -Force | Out-Null
# Only administrators and SYSTEM may change this machine-wide trust bundle.
& icacls.exe $directory /inheritance:r /grant:r '*S-1-5-18:(OI)(CI)F' '*S-1-5-32-544:(OI)(CI)F' '*S-1-5-32-545:(OI)(CI)RX' | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Could not protect the certificate directory.' }
$bundle = Join-Path $directory 'roots.pem'
$candidate = Join-Path $directory 'roots.candidate.pem'
$pem = "`r`n-----BEGIN CERTIFICATE-----`r`n" + [Convert]::ToBase64String($cert.RawData, [Base64FormattingOptions]::InsertLineBreaks) + "`r`n-----END CERTIFICATE-----`r`n"
[IO.File]::WriteAllText($candidate, [IO.File]::ReadAllText($googleRoots) + $pem, [Text.Encoding]::ASCII)
# HTTP 404 is expected here; the check verifies TLS, not OAuth credentials.
& "$env:SystemRoot\System32\curl.exe" --silent --show-error --head --max-time 30 --cacert $candidate https://oauth2.googleapis.com/token | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'TLS verification failed with the proposed certificate bundle; settings were not changed.' }
$key = 'HKLM:\Software\Google\DriveFS'
if (!(Test-Path $key)) { New-Item -Path $key | Out-Null }
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
& reg.exe export 'HKLM\Software\Google\DriveFS' (Join-Path $directory "settings-before-$stamp.reg") /y | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Could not back up existing Drive settings.' }
if (Test-Path -LiteralPath $bundle) { Copy-Item -LiteralPath $bundle -Destination (Join-Path $directory "roots-before-$stamp.pem") }
Move-Item -LiteralPath $candidate -Destination $bundle -Force
New-ItemProperty -Path $key -Name TrustedRootCertsFile -PropertyType String -Value $bundle -Force | Out-Null
New-ItemProperty -Path $key -Name DisableSSLValidation -PropertyType DWord -Value 0 -Force | Out-Null
New-ItemProperty -Path $key -Name DisableCRLCheck -PropertyType DWord -Value 0 -Force | Out-Null
Write-Host "Configured Google Drive trust for $($cert.Subject). Restart Drive as your normal Windows user."
