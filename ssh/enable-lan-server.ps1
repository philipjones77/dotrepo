#Requires -Version 5.1
#Requires -RunAsAdministrator
[CmdletBinding()]
param(
    [string]$PeerIPv4,
    [string[]]$AdministratorPublicKey = @(),
    [string[]]$AdministratorPublicKeyFile = @()
)

$ErrorActionPreference = 'Stop'

foreach ($publicKeyFile in $AdministratorPublicKeyFile) {
    $AdministratorPublicKey += @(Get-Content -LiteralPath $publicKeyFile | ForEach-Object { $_.Trim() } | Where-Object { $_ -and !$_.StartsWith('#') })
}

# Run locally on each Windows PC. This script never generates or copies private keys.
$remoteAddress = 'LocalSubnet'
if ($PeerIPv4) {
    $parsedAddress = [System.Net.IPAddress]::Parse($PeerIPv4)
    if ($parsedAddress.AddressFamily -ne [System.Net.Sockets.AddressFamily]::InterNetwork) {
        throw '-PeerIPv4 must be a single IPv4 address.'
    }
    $remoteAddress = $parsedAddress.ToString()
}
foreach ($publicKey in $AdministratorPublicKey) {
    if ($publicKey -notmatch '^(ssh-ed25519|ecdsa-sha2-nistp(?:256|384|521)|ssh-rsa) ([A-Za-z0-9+/]+={0,3})(?: [^\r\n]*)?$') {
        throw 'Supply a complete OpenSSH public-key line, without authorized_keys options.'
    }
    [void][Convert]::FromBase64String($Matches[2])
}
if (!(Get-NetConnectionProfile | Where-Object NetworkCategory -eq 'Private')) {
    throw 'No Private network is active. Mark the verified home LAN Private before running this script.'
}

$capability = Get-WindowsCapability -Online -Name 'OpenSSH.Server~~~~0.0.1.0'
$restartNeeded = $false
if ($capability.State -ne 'Installed') {
    $installation = Add-WindowsCapability -Online -Name 'OpenSSH.Server~~~~0.0.1.0'
    $restartNeeded = [bool]$installation.RestartNeeded
}

$sshDirectory = Join-Path $env:ProgramData 'ssh'
$sshProgramDirectory = Join-Path $env:WINDIR 'System32\OpenSSH'
$sshd = Join-Path $sshProgramDirectory 'sshd.exe'
$configPath = Join-Path $sshDirectory 'sshd_config'
$keyPath = Join-Path $sshDirectory 'administrators_authorized_keys'
$backupDirectory = Join-Path $sshDirectory ('dotrepo-backups\' + (Get-Date -Format 'yyyyMMdd-HHmmss-fff'))
New-Item -ItemType Directory -Path $sshDirectory -Force | Out-Null
New-Item -ItemType Directory -Path $backupDirectory -Force | Out-Null

# Installation creates a permissive rule. Restrict it before configuration/key
# work so a later validation failure cannot leave the installer defaults active.
$ruleName = 'OpenSSH-Server-In-TCP'
$rule = Get-NetFirewallRule -Name $ruleName -ErrorAction SilentlyContinue
if ($rule) {
    $rule | Export-Clixml -LiteralPath (Join-Path $backupDirectory 'firewall-rule.xml')
    $rule | Get-NetFirewallAddressFilter | Export-Clixml -LiteralPath (Join-Path $backupDirectory 'firewall-address.xml')
    $rule | Set-NetFirewallRule -Enabled True -Profile Private -Direction Inbound -Action Allow -Protocol TCP -LocalPort 22 -RemoteAddress $remoteAddress
} else {
    New-NetFirewallRule -Name $ruleName -DisplayName 'OpenSSH LAN access' -Enabled True -Profile Private -Direction Inbound -Action Allow -Protocol TCP -LocalPort 22 -RemoteAddress $remoteAddress | Out-Null
}
if ($restartNeeded) {
    throw 'Windows requires a restart to finish OpenSSH installation. The firewall rule is restricted; restart, then rerun this script.'
}

if (!(Test-Path -LiteralPath $configPath)) {
    Copy-Item -LiteralPath (Join-Path $sshProgramDirectory 'sshd_config_default') -Destination $configPath
}
Copy-Item -LiteralPath $configPath -Destination (Join-Path $backupDirectory 'sshd_config')

# Keep all unrelated settings and Match blocks. Fail rather than silently alter
# conditional authentication policies or included configurations we have not reviewed.
$configLines = [System.IO.File]::ReadAllLines($configPath)
if ($AdministratorPublicKey.Count -gt 0 -and !($configLines -match '^\s*AuthorizedKeysFile\s+__PROGRAMDATA__/ssh/administrators_authorized_keys\s*(?:#.*)?$')) {
    throw "The expected administrator AuthorizedKeysFile is absent. Review $configPath before adding keys."
}
$insideMatch = $false
$retainedLines = [System.Collections.Generic.List[string]]::new()
foreach ($line in $configLines) {
    $directive = $line.Trim()
    if ($directive -match '^Include\s') {
        throw "Existing Include directive needs review before automatic configuration. Backup: $backupDirectory"
    }
    if ($directive -match '^Match\s') { $insideMatch = $true }
    if ($insideMatch -and $directive -match '^(AuthenticationMethods|PasswordAuthentication|PubkeyAuthentication)\s') {
        throw "Existing conditional authentication policy needs review. Backup: $backupDirectory"
    }
    if (!$insideMatch -and $directive -match '^(AuthenticationMethods|PasswordAuthentication|PubkeyAuthentication)\s') {
        continue
    }
    if ($directive -eq '# dotrepo LAN authentication defaults') { continue }
    $retainedLines.Add($line)
}
$managedLines = @(
    '# dotrepo LAN authentication defaults',
    'AuthenticationMethods publickey',
    'PubkeyAuthentication yes',
    'PasswordAuthentication no'
)
$utf8 = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllLines($configPath, [string[]]($managedLines + $retainedLines.ToArray()), $utf8)

# Generate missing HOST keys locally; existing host keys are preserved by -A.
& (Join-Path $sshProgramDirectory 'ssh-keygen.exe') -A
if ($LASTEXITCODE -ne 0) {
    Copy-Item -LiteralPath (Join-Path $backupDirectory 'sshd_config') -Destination $configPath -Force
    throw 'Host-key creation failed; original sshd_config restored.'
}
& $sshd -t -f $configPath
if ($LASTEXITCODE -ne 0) {
    Copy-Item -LiteralPath (Join-Path $backupDirectory 'sshd_config') -Destination $configPath -Force
    throw 'sshd configuration validation failed; original sshd_config restored.'
}

if ($AdministratorPublicKey.Count -gt 0) {
    # The standard Windows Match Group administrators block selects this file.
    if (Test-Path -LiteralPath $keyPath) {
        Copy-Item -LiteralPath $keyPath -Destination (Join-Path $backupDirectory 'administrators_authorized_keys')
        (Get-Acl -LiteralPath $keyPath).Sddl | Set-Content -LiteralPath (Join-Path $backupDirectory 'administrators_authorized_keys.acl.txt')
    }
    foreach ($publicKey in $AdministratorPublicKey) {
        $keyBlob = ($publicKey -split ' ', 3)[1]
        $existingText = if (Test-Path -LiteralPath $keyPath) { [System.IO.File]::ReadAllText($keyPath) } else { '' }
        if ($existingText -notmatch ('(?m)(?:^|\s)' + [regex]::Escape($keyBlob) + '(?:\s|$)')) {
            [System.IO.File]::AppendAllText($keyPath, "`r`n$publicKey`r`n", $utf8)
        }
    }
    $keyAcl = [System.Security.AccessControl.FileSecurity]::new()
    $keyAcl.SetAccessRuleProtection($true, $false)
    $keyAcl.SetOwner([System.Security.Principal.SecurityIdentifier]::new('S-1-5-32-544'))
    foreach ($sid in @('S-1-5-18', 'S-1-5-32-544')) {
        $identity = [System.Security.Principal.SecurityIdentifier]::new($sid)
        $access = [System.Security.AccessControl.FileSystemAccessRule]::new($identity, 'FullControl', 'Allow')
        $keyAcl.AddAccessRule($access)
    }
    Set-Acl -LiteralPath $keyPath -AclObject $keyAcl
}

Set-Service -Name sshd -StartupType Automatic
if ((Get-Service -Name sshd).Status -eq 'Running') {
    Restart-Service -Name sshd
} else {
    Start-Service -Name sshd
}

Write-Host "Windows host: $env:COMPUTERNAME"
Write-Host "Inbound SSH: Private profile, TCP 22, source $remoteAddress"
Write-Host "Configuration backup: $backupDirectory"
Write-Host 'Compare this host fingerprint on the connecting PC before accepting it:'
& (Join-Path $sshProgramDirectory 'ssh-keygen.exe') -lf (Join-Path $sshDirectory 'ssh_host_ed25519_key.pub') -E sha256
if ($LASTEXITCODE -ne 0) { throw 'Could not display the host fingerprint.' }
Get-Service -Name sshd
Write-Host 'Password login is disabled. A matching authorized public key is required.'
Write-Host 'Other pre-existing firewall allow rules, if any, must be reviewed separately.'
