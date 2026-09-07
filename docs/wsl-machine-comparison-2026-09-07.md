# WSL comparison between the two computers

Reviewed on 2026-09-07. **WSL on PhilipSecond is healthy; no reinstall or rebuild
is indicated. It is not an exact copy of the other computer.**

This computer was checked live. The other computer's evidence is its
[recovery report](recovery-2026-09-06.md) through commit `16e466f`; this review did
not run commands remotely on that computer. Its report confirms that Ubuntu has
now been recovered and booted, superseding the earlier pending-import status.

| Area | PhilipSecond, checked here | Other computer, latest committed report |
| --- | --- | --- |
| WSL / Ubuntu | WSL 2, Ubuntu 24.04; systemd enabled; no pending APT upgrades; dpkg audit clean | Recovered original Ubuntu on WSL 2.7.13; post-recovery package audit passed |
| Account | Only personal user `phili`, UID 1001; home and Bash startup checked | Original `phili`, UID 1000, restored |
| Limits | 16 GB WSL memory cap, active 24 GB swap; source has 32 GB RAM | 8 GB memory cap, 4 GB swap recorded; target has 16 GB RAM |
| Conda environments | Miniforge base (Python 3.13.13) and jax (Python 3.12.13), plus dotrepo venv | Base and six non-base environments preserved; includes bnf-env, jax, uqpy and rqs; more project environments than here |
| JAX GPU | JAX 0.10.2, RTX 5070 Laptop; fresh CUDA calculation passed | JAX 0.10.1, RTX 4070 Laptop; float64 matrix/JIT-gradient checks reported passed |
| R | System R 4.6.1; all 72 recorded package namespaces previously checked | System R 4.6.1 plus the separate rqs environment tested |
| TeX | Ubuntu-managed TeX Live 2023; pdfLaTeX, XeLaTeX, LuaLaTeX and Biber verified | TeX Live 2023; PDF/Lua/BibTeX checked; XeLaTeX and Biber reported absent |
| AI command-line tools | agy 1.1.27 available; standalone codex, claude and gemini commands absent from the checked PATH | Codex 0.153.4, Claude 2.1.263, Gemini 0.58.0 and agy 1.1.27 reported available |
| Native Linux AI desktops | chatgpt and antigravity hub commands absent from the checked PATH | Linux ChatGPT preview and Antigravity hub installed and WSLg window launches tested |
| Editors | Existing Codex/Claude/Python/R/LaTeX extensions; native PowerShell 7.6.5; shared launchers refreshed during this review | Actual WSL VS Code and Antigravity extension-host checks reported passed |
| rclone | Ubuntu package reports 1.60.1-DEV | Preserved standalone rclone 1.74.2 |
| Google Drive | Existing mount is **read-only**; persistent Windows login anchor not registered | Writable mount and login anchor tested, including stop/start behavior |

## Work completed during this review

- Pulled the other computer's new shared launchers and Drive helper changes into
  both local checkouts. Applied native WSL bootstrap with backups, installing
  `~/.local/bin/code` and `~/.local/bin/antigravity-ide`.
- Verified the new launchers execute; VS Code reports 1.136.1. Antigravity's
  launcher reports its underlying editor build 1.107.0; that is not its separately
  registered product version.
- Re-ran WSL doctor after bootstrap: all required checks passed. Both Conda
  environments pass pip dependency checks. Systemd has no reported failed units.
- Re-ran a small JAX GPU operation with preallocation disabled for the check;
  `cuda:0` computed a dot product of 14. Verified a new login starts as `phili`
  in `/home/phili`. The filesystem has substantial free space.
- Preserved the user's untracked native `dotrepo.code-workspace-linux.code-workspace`.

## What needs doing, if feature parity is wanted

1. Add the standalone AI CLIs or Linux desktop apps only if those workflows are
   wanted here. Installed VS Code AI extensions are separate from standalone CLIs.
2. Review upgrading this computer's older rclone. Decide whether Drive here should
   be writable and persist after terminals close; then apply the documented login
   anchor. This review did not change cloud write permissions or startup policy.
3. Reproduce only needed project environments from the other computer's actual
   manifests. Do not replace working environments or downgrade JAX merely to match
   version strings. A complete package-by-package comparison requires an updated
   shareable inventory from the other computer, not just its recovery narrative.
4. If the requested 24 GB swap is meant for both machines, reconcile the other
   computer's recorded 4 GB setting there. Different memory caps are appropriate
   for their different physical RAM. The differing user UIDs are normal and do
   not require changing ownership on either machine.

No missing dependency or broken base setup currently requires rebuilding WSL.
The unresolved source provenance for fftlog-lss remains a **reconstruction gap**,
not evidence that its existing installed environment is broken.
