# Projects used from Windows and WSL

Every repository may support both environments. Support is declared per project and tested; it is not inferred merely because a checkout exists.

| Item | Windows | WSL |
| --- | --- | --- |
| Checkout | `C:\dev\PROJECT` | `~/projects/PROJECT` |
| Python environment | Native Windows venv/Conda | Native Linux venv/Conda |
| Build outputs and caches | Inside the Windows checkout or native cache | Inside the Linux checkout or native cache |
| GitHub Git access | Windows SSH key | WSL SSH key |
| Shared source/config | Same upstream Git repository and reviewed definitions | Same upstream Git repository and reviewed definitions |

Use Git commits and pulls to transfer source changes. Do not copy `.git`, virtual environments, `node_modules`, build trees, or caches between platforms or sync live checkouts through Google Drive. A Windows editor can open a WSL checkout through VS Code Remote WSL; commands for that checkout still run inside WSL. Reserve `/mnt/c` access for orchestration and deliberate file exchange.

Run `scripts/dotrepo.ps1 -Action projects -Platform all` for a read-only checkout audit. It records branch, HEAD, dirty state, effective remote URLs and an optional platform contract. JSON output is available with `python scripts/projects.py --root C:/dev --json` or `python3 scripts/projects.py --root ~/projects --json`. It scans direct child repositories only, skips hidden/underscore directories and symlinks, and never pulls, commits, resets, changes branches, or executes project commands.

Copy `config/project-template.json` to `.dev-environment.json` in each project when formalizing its support. Fill in the actual setup/test command arrays and platform exceptions. Empty arrays are explicitly unspecified. The audit records declarations but does not claim their commands have passed. Project workflows must run those real setup/test commands on their supported Windows/Linux runners; GPU or licensed-software checks may need separate runners.

For two checkouts of a project, compare remote, branch, revision, local changes and package inventories. Different commit IDs or dirty files require review before synchronization. Do not overwrite one checkout to force equality. Use separate platform names/emails if desired; author identity does not change which upstream a project tracks.

Colab support is a separate declaration. Mount user data with Colab's Drive integration and use project-specific notebook dependencies. GitHub Actions validates committed code in clean runners, without local personal mounts or shell state.

No project repositories outside dotrepo are modified automatically by these tools. The second machine's projects and preferred Bash configuration remain to be inspected.
