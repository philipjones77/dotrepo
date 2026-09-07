# PhilipSecond WSL follow-up — September 7, 2026

The user removed `~/.virtualenvs/jax-native` and `~/.virtualenvs/matrix-compare`.
No running processes used either environment at removal. The retained standard
CPython environments are `jax` (3.12.3) and `py313` (3.13.15); no Conda was added.
The old kernel registrations for the removed environments were removed too.
The VS Code default interpreter, `jaxenv` helper and data77 launcher use `py313`.
Its dependency check and the Approach B runner's imports/help passed. This does
not establish full experiment parity. Earlier JAX/matrix validation reports and
requirements snapshots describe the now-removed environments.

## Writable Drive mounts

Local `~/.config/dotrepo/gdrive.env` selects `gdrive:`, `$HOME/mnt/gdrive` and
`DOTREPO_GDRIVE_READ_ONLY=0`. The shared helper uses VFS write caching and now
allows 90 seconds for daemon startup, because the earlier 30-second attempt
timed out. The shell-startup marker remains enabled. Credentials stay local.

Drive for desktop starts at Windows login and provides G:. The following entry
was added to this machine's `/etc/fstab`:

```fstab
G: /mnt/g drvfs rw,uid=1001,gid=1001,nofail,x-systemd.automount,x-systemd.mount-timeout=15s 0 0
```

For another computer, verify its Drive letter and replace UID/GID with `id -u`
and `id -g`. After creating `/mnt/g`, reload systemd and start
`mnt-g.automount`. Access to `/mnt/g` then triggers the mount. Drive for desktop
must be running in Windows. Both `/home/phili/mnt/gdrive` and `/mnt/g/My Drive`
passed a unique temporary file write/read/delete check. The automount was tested
live, but not across a reboot. These checks do not prove completed cloud sync.

## Other-computer JAX reference still needed

Remote commit `4f27fe5` records PC-PHILIP-WINDO's Windows library parity and
explicitly says WSL was left unchanged. It contains no fresh target WSL package
inventory. No JAX upgrade or cross-machine WSL parity is claimed from that report.
The retained `jax` environment currently reports JAX/jaxlib/CUDA 12 plugins
0.11.1 and NumPyro 0.21.0. A GPU JIT float64 linear solve passed. Its dependency
check still reports GPflow 2.11.0 requiring NumPy below 2 while NumPy 2.4.6 is
installed. No package changes were made during this follow-up; it awaits an
identified replacement library baseline. Default GPU preallocation produced
allocation warnings with other GPU memory in use, although the solve completed.
