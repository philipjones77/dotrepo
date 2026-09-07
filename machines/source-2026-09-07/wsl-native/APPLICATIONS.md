# PhilipSecond WSL application inventory

Refreshed September 7, 2026 from the live Ubuntu installation.

| Inventory | Contents |
| --- | --- |
| [Applications](applications.json) | 25 available commands with version output, 18 desktop entries, MATLAB/Wolfram installation locations, npm globals and available Snap/Flatpak inventories |
| [APT packages](apt-installed.json) | All 1,356 installed Ubuntu packages and versions, including scientific native libraries |
| [Manual APT selections](apt-manual.txt) | 156 explicitly selected packages |
| [R packages](r-packages.tsv) | Packages visible to the configured native R installation |
| [Python environments](standard-python/environments.json) | Current `py313`, `jax313` and `jax314` versions and package counts; individual package inventories are beside this file |
| [VS Code extensions](vscode-extensions.json) | Installed WSL server extensions |
| [Distribution](distribution.json) | Ubuntu release information |
| [Capture metadata](capture.json) | Capture timestamp and inventory scope |

Highlights include MATLAB R2026a Update 5, installed Wolfram 15.0 and retained
14.3 trees, R 4.6.1, Ubuntu TeX Live 2023, PowerShell 7.6.5, Node 24.20.0,
Claude Code 2.1.263, Codex CLI 0.153.4, Gemini CLI 0.58.0 and Google Cloud SDK
583.0.0. WolframScript's own version is distinct from the Wolfram application
version; license and runtime verification are documented in the earlier reports.

These records describe this machine's installed state at capture time. They
include no license keys, credentials or installers. Command presence and version
output do not establish authentication or complete application functionality.
`native-tools.json` retains earlier validation history and is not a substitute
for the freshly captured inventories above. Package additions made in other
sessions are reflected in the latest Python inventories without claiming they
were validated during this read-only capture.
