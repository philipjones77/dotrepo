# AI tools in Bash and WSL

Keep native Linux tools and project environments on the Linux PATH. Run the
Windows editors through their Bash launchers; do not add all Windows tool
directories to the Linux PATH.

`bash bootstrap/install.sh` installs `~/.local/bin/code` and
`~/.local/bin/antigravity-ide`, backing up any previous launchers. They discover
the current Windows user's installation. For a custom IDE installation, set
`DOTREPO_WINDOWS_ANTIGRAVITY_IDE_BIN` to its executable Linux
`/mnt/.../bin/antigravity-ide` path in the private shell configuration.

Use `code .` for the standard VS Code Remote WSL workflow. To open the current
Linux folder explicitly in Antigravity IDE, run:

```bash
folder_uri=$(python3 - <<'PY'
import os
from urllib.parse import quote
print("vscode-remote://wsl+" + quote(os.environ["WSL_DISTRO_NAME"], safe="")
      + quote(os.getcwd(), safe="/"))
PY
)
antigravity-ide --folder-uri "$folder_uri"
```

The tested Windows Antigravity IDE 2.5.5 includes Google's own **Antigravity
Remote - WSL** extension. Its bundled README supports Windows 11 with WSL 2;
`wget` or `curl` must be available in Ubuntu. Use this bundled integration and
keep server checksum verification enabled. Do not copy Microsoft Remote WSL
extensions into another editor. The IDE's `--version` currently prints the
underlying Code version, 1.107.0; the Windows product version is 2.5.5.

Native Bash commands are `codex`, `claude`, `gemini`, and `agy`. Use the vendor
installation/update routes, preserving each platform's own authentication:

- [Codex CLI](https://learn.chatgpt.com/docs/codex/cli): official standalone
  installer, with its checksum verification.
- [Claude Code](https://code.claude.com/docs/en/installation): official native
  installer.
- [Gemini CLI](https://geminicli.com/docs/get-started/installation/): retain its
  dedicated Node environment here, rather than changing scientific environments.
- [Antigravity CLI](https://www.antigravity.google/docs/cli/install/): native
  installer and `agy update`.

Google has [retired consumer Gemini Code Assist and Gemini CLI “Login with
Google”](https://developers.google.com/gemini-code-assist/docs/deprecations/code-assist-individuals).
An installed Gemini CLI does not prove that consumer sign-in remains supported.
Use Google's documented Antigravity migration route for that workflow;
Standard/Enterprise account arrangements are separate.

The native `antigravity` command opens the Linux Antigravity desktop hub.
The native `chatgpt` command opens the official
[ChatGPT Linux preview](https://learn.chatgpt.com/docs/linux/linux-app), installed
from its vendor DEB. The package configures an HTTPS APT repository with its own
signing key. Keep the normal sandbox and package-owned AppArmor profile. WSLg
window launch was tested on this machine; this does not establish support for
every feature of the Linux preview or complete an account sign-in.

Recovery verification on 2026-09-07: native Codex 0.153.4, Claude Code 2.1.263,
Gemini CLI 0.58.0, Antigravity CLI 1.1.27, Antigravity hub 2.12.2, and ChatGPT
Linux preview 26.901.51231. ChatGPT and the Antigravity hub opened real WSLg
windows as UID 1000. Antigravity IDE connected to a real Linux extension host
and exercised Bash, the preserved Python interpreter, Git, and document editing.
Desktop AI account onboarding and paid model requests were not exercised.
