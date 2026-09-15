# Adobe Acrobat and Windows app inventory — PhilipSecond

The user requested Adobe Acrobat on this Windows computer and a check for
missing applications. This report is separate from the other computer's
[September 7 restoration](acrobat-restore-2026-09-07.md).

## Package selection

WinGet identified `Adobe.Acrobat.Pro` version **26.002.21901**, released
September 8, 2026. This is Adobe's full 64-bit Acrobat desktop installer.
Pro/Standard features require the user's existing Adobe entitlement.

- [Adobe installer](https://helpx.adobe.com/acrobat/kb/download-64-bit-installer.html)
- [Adobe release history](https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/index.html)

WinGet's initial download stalled at zero bytes. The same Adobe-hosted ZIP was
downloaded directly for verification against WinGet's SHA-256:
`ECE5D3816C32DE1374B1D228B04D01ABB1621A7AEA6D61728D97A65718053035`.
Private staging and installation evidence are under `.local/acrobat-20260912/`.

## Acrobat installation result

The initial Windows administrator prompt was canceled. At the user's request,
setup was retried with elevation and completed with **exit 0**. The installed
executable reports **26.2.21901.0** and has a valid Adobe signature.
`ADDLOCAL=ALL` requested the optional components; automatic restart was suppressed.

Acrobat and Distiller are registered in the Start menu. PaperCapture/OCR,
Preflight and Distiller files are present. The Adobe PDF printer is registered
with the Adobe PDF Converter driver. A generated local PDF was passed to Acrobat
for a launch check, and Acrobat processes were responsive; document rendering and paid-account activation were not
visually verified. Sign in with the existing Adobe account for licensed features.

## Other applications

The current WinGet export contains all package IDs in the recorded September 7
source Windows WinGet inventory. Desktop registry comparison found the Office
display-name change: Microsoft 365 Apps for enterprise remains installed at
16.0.20326.20132.

Two additional entries in the optional `windows/packages/winget-packages.txt`
toolchain list were absent from WinGet, the inspected desktop registry, PATH
and their standard installation locations:

- Docker Desktop (`Docker.DockerDesktop`).
- Temurin Java 21 JRE (`EclipseAdoptium.Temurin.21.JRE`).

`uv` is already installed at `C:\Users\phili\.local\bin\uv.exe` despite not
being registered with WinGet. The user subsequently authorized installing Docker
and Temurin; their separate installer records are in `.local/windows-install-20260912/`.
Both installers were downloaded and their hashes and publisher signatures verified.
The separate Windows administrator prompt was initially canceled. At the user's
request it was reopened and approved; both installers then completed with exit 0.
Temurin reports OpenJDK **21.0.12.1+1 LTS**, with machine `JAVA_HOME` configured.
Docker Desktop **4.90.0 (238679)** has a valid publisher signature. After startup,
`docker version` successfully contacted the Linux engine through `desktop-linux`:
both client and server report **29.7.2**. No reboot was performed.
This comparison is scoped to the recorded
desktop/WinGet baseline; it is not a verification of every Store application,
license, plugin or application workflow. The Microsoft Store source failed
during the initial Acrobat query; the explicit WinGet source worked.
