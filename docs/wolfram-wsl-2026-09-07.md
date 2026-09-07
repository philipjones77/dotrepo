# Mathematica update in Ubuntu WSL

On 2026-09-07, installed Wolfram/Mathematica **15.0.1** and English local
documentation from the official [Wolfram download center](https://www.wolfram.com/download-center/).
The Linux bundled installer passed its embedded checksum check and exited 0.

- Application: `/usr/local/Wolfram/Wolfram/15.0`
- Documentation: `/usr/share/Wolfram/Documentation/15.0`
- Previous working version: `/usr/local/Wolfram/Wolfram/14.3`

**Activation remains required.** A direct 15.0.1 kernel launch found the existing
`~/.Wolfram/Licensing/mathpass` but rejected it with `Invalid password` and
exit 62. The existing license file was preserved; its contents are not stored
in this repository. Sign in to the new application's activation window using
an account entitled to the new version, or use its supported activation flow.

The existing `/usr/local/bin` launchers continue to select working version 14.3
until the new kernel passes activation and calculation checks. Launch the new
application explicitly with:

```bash
QT_QPA_PLATFORM=xcb LIBGL_ALWAYS_SOFTWARE=1 \
  /usr/local/Wolfram/Wolfram/15.0/Executables/wolframnb
```

After activation, verify the new kernel before updating default launchers:

```bash
/usr/local/Wolfram/Wolfram/15.0/Executables/WolframKernel -noprompt \
  -run 'Print[$Version]; Print[Integrate[x^2,x]]; Exit[]'
```

Installation used `--nox11 -- -auto` with separate application and launcher
directories. The installer inserted a space into the requested `15.0` path;
this was corrected after installation, along with its isolated launcher links.
Installer extraction was restarted in native WSL `/tmp` after the initial
Windows-mounted temporary directory proved slow. The interrupted installer
removed its temporary files. No existing Wolfram installation was removed.

The GUI needed additional Ubuntu libraries: `libxkbcommon-x11-0`,
`libxcb-cursor0`, `libxcb-icccm4`, `libxcb-image0`, `libxcb-keysyms1`,
`libxcb-render-util0`, `libxcb-xkb1` and their dependency `libxcb-util1`.
The activation launch uses XCB and software rendering locally to avoid the
initial WSL graphics errors; no global graphics environment was changed.
The Wolfram Product Activation window was confirmed visible through WSLg.
Installed `wslu` and `desktop-file-utils` so browser links can use Windows
through `wslview`; the browser alternative now resolves to that helper.
