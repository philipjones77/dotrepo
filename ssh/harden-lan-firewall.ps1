#requires -Version 5.1
# Restore the agreed LAN remote-access firewall posture on this PC (run elevated):
#  - the MSI "Preview" sshd rule accepts TCP 22 only from LocalSubnet on the Private profile
#  - the installer-created "TightVNC" rule (Any profile, Any port) is disabled; tvnserver
#    listens on 127.0.0.1:5900 only and is reached through the SSH tunnel.
$ErrorActionPreference = 'Stop'
$log = Join-Path $env:ProgramData 'dotrepo\backups\firewall-' + (Get-Date -Format 'yyyyMMdd-HHmmss')
New-Item -ItemType Directory -Force $log | Out-Null
Get-NetFirewallRule | Where-Object { $_.DisplayName -match 'ssh|vnc|tight' } | ForEach-Object {
    $r = $_; $pf = $r | Get-NetFirewallPortFilter; $af = $r | Get-NetFirewallAddressFilter; $ap = $r | Get-NetFirewallApplicationFilter
    [pscustomobject]@{ Name = $r.DisplayName; InstanceID = $r.InstanceID; Enabled = [string]$r.Enabled; Profile = [string]$r.Profile; Port = $pf.LocalPort; Remote = $af.RemoteAddress; Program = $ap.Program }
} | ConvertTo-Json | Set-Content (Join-Path $log 'before.json')

Get-NetFirewallRule -DisplayName 'OpenSSH SSH Server Preview (sshd)' | Set-NetFirewallRule -Profile Private -RemoteAddress LocalSubnet
Get-NetFirewallRule -DisplayName 'TightVNC' | Where-Object { $_.Direction -eq 'Inbound' } | Disable-NetFirewallRule

Get-NetFirewallRule | Where-Object { $_.DisplayName -match 'ssh|vnc|tight' } | ForEach-Object {
    $r = $_; $pf = $r | Get-NetFirewallPortFilter; $af = $r | Get-NetFirewallAddressFilter
    [pscustomobject]@{ Name = $r.DisplayName; Enabled = [string]$r.Enabled; Profile = [string]$r.Profile; Port = $pf.LocalPort; Remote = $af.RemoteAddress }
} | Format-Table -AutoSize | Out-String | Tee-Object (Join-Path $log 'after.txt')
"Backup of the previous rule state: $log"
