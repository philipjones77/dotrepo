# Two-way LAN SSH between the Windows machines

Date: 2026-09-22. Repository: dotrepo, branch `main`.

Use Windows OpenSSH Server on **both** PCs. Each computer keeps its own
private client key and authorizes only the other computer's public key.
Connections reach Windows first and can then run that user's WSL commands.
GitHub commit/push/pull remains the way to transfer repository changes.

Initial inspection on PC-PHILIP-WINDOWS found OpenSSH Client installed,
OpenSSH Server absent, and Wi-Fi using the Private profile. Its Windows
computer name is `PC-PHILIP-WINDO`; the longer DNS name is
`PC-PHILIP-WINDOWS`. The local shell was not elevated, so server installation
requires a Windows administrator prompt. PhilipSecond's setup and direct
connectivity have not yet been verified. LAN addresses stay in local SSH
configuration rather than this repository.

## One-time server setup on each PC

Use [ssh/enable-lan-server.ps1](../../../ssh/enable-lan-server.ps1) locally on
**each computer**, from PowerShell opened with **Run as administrator**.
The script installs the optional Windows server if missing, saves the existing
configuration, requires public-key authentication, disables password login,
restricts its firewall rule to the Private network profile, enables automatic
startup, validates `sshd_config`, and prints the host fingerprint. Existing
host keys and unrelated settings are preserved. Conditional authentication or
included configurations require review instead of being overwritten.
[Microsoft installation guide](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse),
[server configuration](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh-server-configuration).

On the computer being configured, first identify its login and home adapter:

```powershell
hostname
whoami
Get-NetIPConfiguration | Select-Object InterfaceAlias, IPv4Address, IPv4DefaultGateway
Get-NetConnectionProfile | Select-Object InterfaceIndex, InterfaceAlias, NetworkCategory
```

The actual home LAN must be Private. If it is Public, change only that
verified adapter with `Set-NetConnectionProfile -InterfaceIndex <index>
-NetworkCategory Private`. Use an existing local Windows login; Microsoft
Entra account authentication is unsupported. Do not infer the login merely
from a profile-folder name.

From the target's `C:\dev\dotrepo` checkout, the basic setup is:

```powershell
.\ssh\enable-lan-server.ps1
```

The default firewall source is `LocalSubnet`. To limit it to the peer PC's
single LAN address instead, use `-PeerIPv4 '<PEER-LAN-IP>'`; DHCP reservations
help keep that restriction stable. The script modifies the standard
`OpenSSH-Server-In-TCP` rule. Review other pre-existing SSH allow rules because
they may independently permit broader access. Do not forward router ports or
expose SSH publicly. No WSL port proxy is needed.
[Microsoft firewall options](https://learn.microsoft.com/en-us/powershell/module/netsecurity/new-netfirewallrule).

Running the helper without a public key prepares the service, but a new
installation cannot authenticate clients until their keys are authorized.
This is intentional; there is no temporary password-login stage.

## Authorize PC-PHILIP-WINDOWS on PhilipSecond

A dedicated client key exists only on the current computer at
`~/.ssh/id_ed25519_dotrepo_lan`. Its **public** part is shared in
[machines/pc-philip-windows-2026-09-22/lan-client-ed25519.pub](../../../machines/pc-philip-windows-2026-09-22/lan-client-ed25519.pub).
Its fingerprint is:

```text
SHA256:rCleNXCXcofLnJmDDf66fcm3R7+7cgg7KxdUhhteLbg
```

After pulling this handoff on PhilipSecond, run in an elevated PowerShell from
`C:\dev\dotrepo`:

```powershell
.\ssh\enable-lan-server.ps1 -AdministratorPublicKeyFile .\machines\pc-philip-windows-2026-09-22\lan-client-ed25519.pub
```

This parameter is for an SSH login belonging to the local Administrators
group. Under Windows' default configuration, those logins use
`C:\ProgramData\ssh\administrators_authorized_keys`, not the profile's
`authorized_keys`. The helper preserves existing key lines, avoids duplicate
key material, backs up an existing file and its ACL, and restricts the file's
permissions to SYSTEM and Administrators. This default file is shared by
administrator logins.

For a **standard Windows login**, do not use the administrator-key parameter.
Place the peer's public line in that target user's
`%USERPROFILE%\.ssh\authorized_keys`; preserve existing entries and restrict
write access to that user, SYSTEM, and administrators. Use that user's actual
profile, not a different account used for elevation.
[Microsoft key deployment](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement).

## Create PhilipSecond's own client key for the reverse direction

Run in the intended user's ordinary PowerShell on PhilipSecond:

```powershell
$lanKey = Join-Path $env:USERPROFILE '.ssh\id_ed25519_dotrepo_lan'
if (!(Test-Path -LiteralPath $lanKey)) {
    ssh-keygen.exe -t ed25519 -f $lanKey -C "$env:COMPUTERNAME dotrepo LAN"
    if ($LASTEXITCODE -ne 0) { throw 'Key generation failed.' }
}
ssh-keygen.exe -lf "$lanKey.pub" -E sha256
```

The current computer uses an unpassphrased dedicated key for unattended agent
connections, with its private-file ACL restricted to the current user. On
PhilipSecond, choose the same arrangement for unattended use, or use a
passphrase and load the key into its local `ssh-agent`. Keep the private key
local in either case. For the unattended arrangement, set its private-file
permissions in the same ordinary user shell:

```powershell
$privateAcl = [System.Security.AccessControl.FileSecurity]::new()
$privateAcl.SetAccessRuleProtection($true, $false)
$owner = [System.Security.Principal.WindowsIdentity]::GetCurrent().User
$privateAcl.SetOwner($owner)
$privateAcl.AddAccessRule([System.Security.AccessControl.FileSystemAccessRule]::new($owner, 'FullControl', 'Allow'))
Set-Acl -LiteralPath $lanKey -AclObject $privateAcl
```

Copy **only** `$lanKey.pub` into an appropriately named target machine capsule,
for example `machines/philipsecond-2026-09-22/lan-client-ed25519.pub`, then commit
and push that public file and the sanitized target receipt. Pull them on
PC-PHILIP-WINDOWS and authorize the public file here using the same elevated
helper with `-AdministratorPublicKeyFile`. Never commit a private key or copy
it between computers.
[OpenSSH key commands](https://man.openbsd.org/ssh-keygen).

## Verify the host before the first connection

The helper prints the **server host-key** fingerprint. This is different from
the client public-key fingerprints above. At the destination console, it can
be displayed again with:

```powershell
ssh-keygen.exe -lf "$env:ProgramData\ssh\ssh_host_ed25519_key.pub" -E sha256
```

At the connecting computer, substitute the destination's LAN address and
actual Windows login:

```powershell
$peerAddress = '<PEER-LAN-IP>'
$peerUser = '<PEER-WINDOWS-LOGIN>'
Test-NetConnection -ComputerName $peerAddress -Port 22
ssh.exe -i "$env:USERPROFILE\.ssh\id_ed25519_dotrepo_lan" -o IdentitiesOnly=yes -o PreferredAuthentications=publickey -o HostKeyAlgorithms=ssh-ed25519 "$peerUser@$peerAddress" hostname
```

Compare the first SSH prompt's SHA256 host fingerprint with the value from the
destination's own console before accepting. Do not disable host checking to
get past a mismatch. Confirm that the returned hostname is the intended PC.
Repeat this verification independently in the reverse direction.

Append the appropriate alias to each computer's private `~/.ssh/config.local`,
which the tracked [ssh/config](../../../ssh/config) includes. Use
`philipsecond-lan` for the destination PhilipSecond, and `pc-philip-lan` for
the destination PC-PHILIP-WINDOWS:

```sshconfig
Host philipsecond-lan
    HostName <PHILIPSECOND-LAN-IP>
    User <PHILIPSECOND-WINDOWS-LOGIN>
    IdentityFile ~/.ssh/id_ed25519_dotrepo_lan
    IdentitiesOnly yes
    PreferredAuthentications publickey
    ForwardAgent no
```

## Check Windows and WSL, then pull through GitHub

After the interactive host-fingerprint check, test unattended login:

```powershell
ssh.exe -o BatchMode=yes -o ConnectTimeout=5 philipsecond-lan hostname
ssh.exe philipsecond-lan wsl.exe --list --verbose
ssh.exe philipsecond-lan wsl.exe -d Ubuntu -u phili --exec hostname
ssh.exe philipsecond-lan git -C C:/dev/dotrepo status --short
ssh.exe philipsecond-lan wsl.exe -d Ubuntu -u phili --exec git -C /home/phili/projects/dotrepo status --short
```

Use the actual distro/user if different. WSL installations belong to their
Windows account; connect as the account owning the intended Ubuntu distro.
Preserve target-local edits, then run `git pull --ff-only` in each checkout
using that computer's own GitHub authentication. Do not forward agents or copy
credentials. Run the [Antigravity handoff](2026-09-22-antigravity-vscode-startup.md)
on each target and record its independently verified versions and checks.
[Microsoft WSL commands](https://learn.microsoft.com/en-us/windows/wsl/basic-commands).

The destination must remain powered on and awake. Record connection results
only after these tests pass. To suspend newly configured access, stop `sshd`
and disable its inbound rule on that PC, provided no other SSH workflow
requires them. Backups stay under `C:\ProgramData\ssh\dotrepo-backups`;
private configuration, host keys, and authentication state stay off GitHub.
