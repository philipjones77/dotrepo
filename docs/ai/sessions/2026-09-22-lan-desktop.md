# LAN desktop sharing through SSH

Date: 2026-09-22. Both Windows PCs run Windows 11 Home. Use TightVNC's
Windows Server and Viewer with the previously verified
[LAN SSH connections](2026-09-22-philipsecond-lan-ssh.md).

## Current installation and verification

The user manually installed TightVNC 2.8.88 Server and Viewer on both
**PC-PHILIP-WINDOWS** and **PhilipSecond**. Automated
installer preparation was rejected by approval review, including after the
user explicitly approved it. No automated software installation occurred.

On both PCs, `tvnserver` is Automatic and running. Each machine's existing
primary VNC password was preserved. These service options were applied:

- Allow loopback connections and accept connections only from loopback.
- Keep VNC authentication required and TCP port 5900 unchanged.
- Disable the Java/web viewer.
- Share the existing desktop without disconnecting another viewer.
- Keep the desktop wallpaper visible.

The installer-created inbound TightVNC firewall exception was disabled on
both PCs. Each server listens only on `127.0.0.1:5900`; SSH remains the network
entry point. PhilipSecond's former web listener on port 5800 is gone.
The prior registry configuration and firewall rule were saved locally under
`C:\ProgramData\dotrepo\backups\lan-desktop-*`, restricted to SYSTEM and
Administrators. Those backups can contain authentication configuration and
must stay private on their originating PC.
PhilipSecond's backup directory is
`C:\ProgramData\dotrepo\backups\lan-desktop-20260922-142423`.

Connection checks:

- PhilipSecond could not reach this PC's TCP port 5900 directly over the LAN.
- This PC could not reach PhilipSecond's TCP ports 5800 or 5900 directly over
  the LAN.
- Authenticated SSH local forwards reached the TightVNC servers in both
  directions.
- Both servers returned RFB 3.8 and offered security types 2 and 16,
  requiring authentication; unauthenticated security type 1 was absent.

Desktop rendering, password entry, mouse/keyboard input, and UAC interaction
have not yet been verified.

A subsequent direct Viewer connection from PC-PHILIP-WINDOWS using the peer's
LAN name/address was refused, as expected with loopback-only VNC listeners.
Launching **Other PC Desktop** on PC-PHILIP-WINDOWS established its SSH tunnel
and the Viewer TCP connection through it. The responding Viewer process then
reported the window title **Vnc Authentication**. User password entry and the
resulting desktop session remain unverified; no firewall or listener settings
were changed to address that direct-connection error.

## Desktop shortcut and launcher

The source launcher is [windows/open-lan-desktop.ps1](../../../windows/open-lan-desktop.ps1).
Each computer uses a deployed copy in
`%LOCALAPPDATA%\dotrepo\lan-desktop\open-lan-desktop.ps1` and a machine-local
`connection.json` with its destination alias and `LocalPort: 0`.
Use `philipsecond-lan` on this PC and `pc-philip-lan` on PhilipSecond.
The deployed copies were verified on both PCs with SHA-256
`141318D1DB5DC9A55120FAE16A2A39157C2B41DC007B147E3E072798866C9411`.
The normal TightVNC password prompt handles authentication; the launcher
does not copy, read, store, or change VNC passwords.

The desktop shortcut is named **Other PC Desktop**, so the label remains
correct on the two OneDrive-synced Windows desktops. Its connection settings
remain in each machine's local app-data folder. The shortcut was created and
verified in each PC's OneDrive Desktop folder.

The launcher opens a hidden SSH tunnel with strict host checking, disabled
agent forwarding, and an available loopback port. It verifies the owned
listener and RFB greeting, then opens the normal Viewer window with automatic
scaling. Closing the Viewer closes its tunnel. On failure, it cleans up its
owned processes before displaying an actionable error.

The private SSH aliases now use the bare Windows hostnames after intermittent
`.local` resolution failures. Both aliases were tested with strict host
checking after this change. Host-key and client-key files were preserved.

## Changing options after installation

Open **Start > TightVNC > TightVNC Server (Service Mode) > TightVNC Server -
Control Interface**, or right-click the TightVNC Service tray icon and choose
**Configuration...**. These service settings are separate from application-mode
settings. Service registration and startup are already complete on both PCs.

Use **Other PC Desktop** to open the opposite PC and enter that target PC's
VNC password in the Viewer prompt. Both interactive Viewer connections still
need checking before claiming full desktop validation.

## Security recheck on PC-PHILIP-WINDOWS

The agreed remote-access controls were checked again after the user requested
confirmation. No configuration changes were necessary:

- Windows Firewall is enabled on Domain, Private and Public profiles, with
  default inbound action Block. The current home Wi-Fi profile is Private.
- Both effective SSH inbound rules allow TCP 22 only on the Private profile
  from LocalSubnet. No broader applicable SSH allow rule was found. App
  capability rules that the PowerShell application filter displayed as Any
  retain their package-family restrictions in the underlying rule store.
- Effective SSH authentication requires publickey, with password authentication
  disabled. The administrator authorized-keys file contains the expected
  PhilipSecond client key only. Host private keys and authorized keys retain
  protected SYSTEM/Administrators ACLs; the local client key is limited to the
  current user, SYSTEM and Administrators.
- TightVNC listens only on 127.0.0.1:5900, requires its configured password,
  disables the web viewer and retains its disabled inbound firewall exception.
  Its private configuration backups retain SYSTEM/Administrators-only ACLs.
- The deployed launcher matches the reviewed source and uses strict SSH host
  checking, disabled client agent forwarding and a loopback-only tunnel.
- PhilipSecond could connect with its SSH key but received `Permission denied
  (publickey)` when public-key authentication was disabled. Those negative-test
  clients were stopped after failing to exit promptly following the rejection;
  a normal-key SSH command exited successfully.
- From PhilipSecond, direct TCP 5800/5900 connections were refused. An owned
  temporary SSH tunnel reached RFB 3.8 with security types 2 and 16, without
  unauthenticated type 1. Temporary test processes were cleaned up.

This recheck covers the agreed Windows SSH/TightVNC setup. It is not an
external-internet scan or an audit of the router and unrelated software.

TightVNC documents service mode in its
[installation guide](https://www.tightvnc.com/doc/win/TightVNC_for_Windows-Installation_and_Getting_Started.pdf)
and loopback configuration in its
[configuration guide](https://www.tightvnc.com/doc/win/TightVNC_2.7_for_Windows_Installing_from_MSI_Packages.pdf).
Its [FAQ](https://www.tightvnc.com/faq.php) recommends SSH tunneling for encrypted
transport. No additional router or LAN firewall openings are needed here.
