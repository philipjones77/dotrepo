# Cross-repository PDF opening in SumatraPDF

On PC-PHILIP-WINDOWS, the user requested SumatraPDF for repository PDFs delivered
by any chat AI. The global instruction source is
[`agents/pdf-opening.md`](../../../agents/pdf-opening.md). Apply it with
[`windows/install-pdf-preference.ps1`](../../../windows/install-pdf-preference.ps1).
The installer backs up prior files under `~/.dotrepo-backups/`.

The installer deploys `~/.local/bin/open-pdf.ps1` and managed instruction blocks
to Windows Codex, Claude Code, Gemini CLI, Copilot CLI, and VS Code user prompts.
Agents should directly open completed PDFs; a file link can still locate the
artifact, but its containing chat application controls what a click does.

The local [`dotrepo.sumatra-pdf`](../../../vscode/sumatra-pdf/README.md) VS Code
extension uses supported custom-editor and tab APIs. It routes newly opened PDF
tabs to SumatraPDF, including AI links that force a text editor, and leaves
ordinary files and dirty tabs alone. The user `*.pdf` association is
`dotrepo.sumatraPdf`. LaTeX Workshop remains installed, its View PDF command uses
SumatraPDF, and thesis-specific SyncTeX commands remain intact. Reload existing
VS Code windows and reopen PDF tabs to activate this extension. Both tracked
Windows and WSL editor settings use the same association. Ordinary Windows
bootstrap installs or updates the bundled routing extension and global opener
after merging editor settings, even without `-InstallTools`; it does not depend
on a Marketplace download. WSL remote windows use the Windows UI extension.
Ordinary WSL bootstrap installs `~/.local/bin/open-pdf` and the same global
instructions through `wsl/install-pdf-preference.sh`. The WSL opener converts
Linux paths and invokes the installed Windows PowerShell opener.

Validation on September 23:

- PowerShell parsing, Node syntax, and Windows/WSL path routing passed.
- A real isolated VS Code extension host passed normal PDF custom-editor open,
  forced PDF text-editor open, and preservation of ordinary text tabs.
- Final result: `C:/dev/dotrepo/.local/sumatra-pdf-test/result-final.json`.
- Installed extension and source SHA-256 matched after the asynchronous file
  check update. The SumatraPDF output channel recorded both PDF launch routes.
- SumatraPDF 3.6.1 was responsive; the delivered introduction was present in its
  saved session. Its reused child can exit with code 1 after dispatching DDE;
  the release source initializes that code and does not reset it in that branch.

The Windows `.pdf` UserChoice was still `MSEdgePDF` at verification. SumatraPDF
is registered. The supported completion step is Windows Settings, Default apps,
SumatraPDF, `.pdf`, select SumatraPDF and Set default. The app-specific URI is
`ms-settings:defaultapps?registeredAppUser=SumatraPDF`. Native Computer Use failed
with an unavailable native pipe, including after reset; no protected default-app
hash or other application's registration was changed.

Web-chat/browser viewers are controlled by their own applications. No browser
account preferences were changed. The Antigravity IDE CLI failed extension
enumeration with an unregistered analytics service, so its viewer integration
was not claimed as verified. An initial WSL filesystem probe failed, but a
bounded `wsl -d Ubuntu --exec ...` probe started Ubuntu and succeeded. WSL-native
global instructions were then deployed for the four installed CLI clients,
and the WSL opener successfully launched the introduction through Windows.
Windows VS Code routing supports accessible WSL files without a remote copy.

Sources:

- [Codex global instructions](https://learn.chatgpt.com/docs/agent-configuration/agents-md)
- [Claude Code user instructions](https://code.claude.com/docs/en/memory)
- [Gemini CLI global context](https://geminicli.com/docs/cli/gemini-md/)
- [Copilot CLI user instructions](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-custom-instructions)
- [VS Code custom editors](https://code.visualstudio.com/api/extension-guides/custom-editors)
- [Windows Default Apps URI](https://learn.microsoft.com/en-us/windows/apps/develop/launch/launch-settings#apps)
- [SumatraPDF 3.6.1 startup source](https://github.com/sumatrapdfreader/sumatrapdf/blob/3.6.1rel/src/SumatraStartup.cpp#L2393-L2417)
