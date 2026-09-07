# Adobe Acrobat restoration — 2026-09-07

This record applies to **PC-PHILIP-WINDO** after its Windows reinstall. The user
requested the full Adobe Acrobat desktop application previously installed.
The retained executable in `Windows.old` reported **26.2.21869.0**; there was
no Acrobat registration or Start-menu entry in the current Windows installation.

## Installer selection

Use Adobe's full **64-bit Acrobat Pro/Standard installer**, exposed in WinGet
as `Adobe.Acrobat.Pro`. Its August 3 installer package reports 26.001.21771;
Adobe's subsequent August 31 update brings Acrobat to **26.002.21869**,
matching this machine's previous executable version.

- [Adobe's full Windows installer](https://helpx.adobe.com/acrobat/kb/download-64-bit-installer.html)
- [Adobe's installation and account instructions](https://helpx.adobe.com/acrobat/desktop/get-started/access-the-app/install-acrobat.html)
- [26.002.21869 release notes and signed update download](https://www.adobe.com/devnet-docs/acrobatetk/tools/ReleaseNotesDC/continuous/dccontinuousaug2026.html)

Pro or Standard features depend on the existing Adobe account entitlement.
Installing the desktop files does not prove account activation. Sign in with
the account that owns the previous license; no new subscription was purchased.

## Repeat the installation

Download and extract the full Adobe installer, and obtain the **Acrobat
64-bit** MSP from the reviewed release notes. Check the current package hash
and Adobe signatures before running them. A future rebuild should check the
current release rather than assume the historical versions above remain latest.

From an administrator PowerShell, run the extracted `Setup.exe` with:

```text
/sAll /rs /msi ADDLOCAL=ALL EULA_ACCEPT=YES REBOOT=ReallySuppress MSIRESTARTMANAGERCONTROL=Disable /L*v "C:\path\acrobat-install.log"
```

`ADDLOCAL=ALL` requests the optional tools as well as the main application.
`/rs` and `REBOOT=ReallySuppress` prevent an installer-triggered restart.
See Adobe's [component selection](https://www.adobe.com/devnet-docs/acrobatetk/tools/DesktopDeployment/singleinstaller.html)
and [command-line documentation](https://www.adobe.com/devnet-docs/acrobatetk/tools/DesktopDeployment/cmdline.html).
Run installers in sequence and wait for completion before applying the update:

```powershell
msiexec.exe /p 'C:\path\AcrobatDCx64Upd2600221869.msp' /qn /norestart REBOOT=ReallySuppress MSIRESTARTMANAGERCONTROL=Disable /L*v 'C:\path\acrobat-update.log'
```

Check installer exit codes, the installed executable's signature and version,
Start-menu registration, included components and a real application launch.
Then verify licensed functions after Adobe account sign-in.

## Local evidence and outcome

Private download receipts, signatures, hashes, installer logs and final
verification are kept under `.local/acrobat-restore-20260907/`.
The full ZIP matched the reviewed WinGet SHA-256
`DA305EC497216582B61B7024F6F4E78963E66757983D57675B0DBA40DEA586D1`.
The update had a valid Adobe signature and SHA-256
`F83F8DCDD74A8F75FBC6C3F54611AE632BF5E1B4069052FCC557AFD52E6931AA`.

The full installer and update both returned **exit 0**. Installation completed
at **17:06:50 CDT** with executable version **26.2.21869.0**, matching the
26.002.21869 release. The installed executable has a valid Adobe signature,
and Windows Installer reports the product installed.

The following checks passed:

- Acrobat and Acrobat Distiller appear in the Start menu.
- Distiller, OCR/PaperCapture, optional OCR support and Preflight are installed
  locally, along with the optional-features group and Word/Outlook PDFMaker.
- The **Adobe PDF** printer is registered with the Adobe PDF Converter driver.
- Acrobat launched, remained responsive and visibly rendered the locally
  generated `acrobat-restoration-test.pdf`. The application was left open.

Paid-account activation and licensed PDF editing remain unverified. Sign in
with the existing Adobe account if prompted. Neither installer requested a
restart; Windows was not restarted. The existing Edge PDF default was retained.
WSL and Norton configuration were not changed by this installation.

Optional removal of the downloaded ZIP, MSP and extracted staging directory
was rejected by automatic approval review with **"blocked by policy"**.
No cleanup command ran. Those temporary installer files remain in the private
evidence directory, totaling about **4.00 GiB**; about **79.83 GiB** remained
free on C: at the subsequent check. Adobe's installed maintenance cache and
the previous `Windows.old` installation also remain.
