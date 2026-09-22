# ChatGPT Windows reinstall and graphics-cache repair

Date: 2026-09-22. Host: **PC-PHILIP-WINDOWS**.

The user reported intermittent freezes in the Windows ChatGPT desktop app.
The installed `OpenAI.Codex` package and the current official x64 MSIX both
reported **26.915.4065.0**. This was a repair of the current release, not an
upgrade to a newer version.

## Evidence and action

The available desktop log recorded a recoverable graphics-process crash on
September 21, a shell-environment startup timeout, and a runtime download that
failed once before installing successfully on retry. These are possible leads;
the logs do not establish the cause of every freeze. A memory snapshot also
showed less than 1 GiB free physical memory on this 16 GiB machine.

The official installer was downloaded from the x64 link in
[OpenAI's Windows deployment guide](https://learn.chatgpt.com/docs/enterprise/windows-deployment).
Windows verified its Authenticode signature. Its SHA256 was
`FB4745F5378C8A4122F74643A3C7C1000DA5F4B184F0D9DC9FAF275C79AC73A4`.

After closing the packaged ChatGPT processes, six graphics-cache directories
were moved to a private rollback folder: `GPUPersistentCache`, `GrShaderCache`,
`ShaderCache`, `Default/GPUCache`, `Default/DawnGraphiteCache`, and
`Default/DawnWebGPUCache`. Browser preferences were backed up locally. Cookies,
authentication stores, chat/session stores, and `.codex` were not reset or
transferred.

The signed package was reapplied with `Add-AppxPackage -Path ...
-ForceApplicationShutdown -ForceUpdateFromAnyVersion`. The command succeeded,
the registered package remained version **26.915.4065.0** with status **Ok**,
and ChatGPT was relaunched through its registered Windows application entry.

Private installer, backups, and the detailed repair receipt are under
`~/.local/state/dotrepo/chatgpt-repair-2026-09-22/` on Windows. These files remain
outside Git. Keep the cache backups until normal use confirms stability.

## Verification limits and the other machine

After relaunch, ten fresh ChatGPT processes reported responding, all six graphics
caches were recreated, and the diagnostic session reported `ok` with zero errors.
No new graphics crash was observed in the available diagnostics. Fresh desktop
log files were still buffered, so this is a startup check rather than a prolonged
stability result. The [sanitized receipt](../../../machines/pc-philip-windows-2026-09-22/chatgpt-windows-repair.json)
records the package and startup checks.

Package deployment and relaunch do not prove that an intermittent freeze is
resolved. Observe the repaired app during normal use, and inspect fresh logs
if the symptom recurs. No unrelated applications or WSL jobs were stopped.

On PhilipSecond, inventory its own ChatGPT package and check the current official
release before updating. Do not repeat a profile/cache repair merely to match
this machine; diagnose any local symptom first. Preserve that machine's own
sign-in and pairing data. Pulling this handoff does not install or repair an app.
