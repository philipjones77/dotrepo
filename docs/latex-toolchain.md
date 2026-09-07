# LaTeX setup on another machine

The reviewed versions and official archive hashes are in
[`config/latex-toolchain.json`](../config/latex-toolchain.json). This optional
profile complements the normal [machine bootstrap](windows-wsl-maintenance.md).
It does not change thesis source files, global TeX search paths, or the shared
editor settings. The target machine still needs its own installation and build
verification; the source machine's successful checks are not target evidence.

The September 7 baseline is Fira Code 6.2 (six static TTF faces, internal version
6.002), Temurin Java 21, SumatraPDF 3.6.1, LaTeX Workshop 10.18.0, and VS Code
1.136.1. Bib2Gls 4.7 with its matching parser was checked against Ubuntu TeX Live
2023 and glossaries-extra 1.53: a repository-relative bibliography and a record
in a child `tracks/*.aux` file produced the expected glossary entry. Earlier
Bib2Gls 3.8/3.9 has a [documented output-directory bug](https://github.com/nlct/bib2gls/issues/29).

## Windows

From the target's dotrepo checkout in a fresh PowerShell session, inspect the
installed applications first. The versions below come from the manifest; do
not downgrade a newer compatible installation merely to match an observation.

Java and Sumatra are included in the reviewed Windows package list. The current
Windows bootstrap's `-InstallTools` option installs extensions and npm packages;
use the WinGet commands below for these applications. Font installation and the
optional Linux glossary-backend override are separate, explicit steps.

```powershell
$latex = Get-Content .\config\latex-toolchain.json -Raw | ConvertFrom-Json
winget list --id EclipseAdoptium.Temurin.21.JRE --exact
winget list --id SumatraPDF.SumatraPDF --exact
code --version
code --list-extensions --show-versions | Select-String 'latex-workshop'

# Run for missing applications or reviewed upgrades; the installer may request elevation.
winget install --id $latex.windows.java.winget_id --exact --version $latex.windows.java.version
winget install --id $latex.windows.sumatra.winget_id --exact --version $latex.windows.sumatra.version
code --install-extension "$($latex.latex_workshop.extension_id)@$($latex.latex_workshop.version)" --force

# Installs only the six reviewed fonts for the current Windows user.
python .\scripts\latex-toolchain.py --install fira_code
```

An existing compatible JRE/JDK is sufficient. The thesis build script discovers
Java through PATH, `JAVA_HOME`, or conventional Windows Adoptium/Java installation
directories, checks it before the first full LaTeX pass, and temporarily exposes
its `bin` directory to Bib2Gls. Do not copy another user's absolute Java path.
Install or update VS Code through its existing installer or
`winget upgrade --id Microsoft.VisualStudioCode --exact`; the recorded baseline
already satisfies the tested LaTeX Workshop requirement.
The pinned Java installer version is present in the
[official WinGet manifest](https://github.com/microsoft/winget-pkgs/blob/master/manifests/e/EclipseAdoptium/Temurin/21/JRE/21.0.12.101/EclipseAdoptium.Temurin.21.JRE.yaml).

Install a complete [TeX Live](https://tug.org/texlive/acquire-netinstall.html)
distribution. Update its programs and packages together using TeX Live Manager,
then wait for that operation to finish before any compile. An in-progress update
can temporarily remove `l3backend-luatex.def`. Keep Biber and BibLaTeX from the
same distribution; do not put current package files into an older LaTeX kernel.
Windows Bib2Gls should be updated through this distribution, not the optional
Linux user override below. Restart VS Code after fonts, applications, or PATH
changes.

## Optional WSL / Ubuntu build environment

Use the target user's native dotrepo clone, normally `~/projects/dotrepo`.
For Windows dispatch, set the actual distribution explicitly, for example
`$distribution = 'Ubuntu'`, then use `wsl -d $distribution -- ...`. Installation
commands below run inside that distribution as its ordinary user.

Keep Ubuntu TeX packages on one release. On a target missing the required
programs/packages, install the matching distro packages deliberately:

```bash
sudo apt update
sudo apt install texlive-luatex texlive-latex-extra texlive-fonts-extra \
  texlive-science texlive-bibtex-extra biber default-jre python3-pygments
# PowerShell 7 is also required by the thesis build entry point.
pwsh --version
cd ~/projects/dotrepo
python3 scripts/latex-toolchain.py --install fira_code
python3 scripts/latex-toolchain.py --install bib2gls
```

Install native PowerShell through the existing
[Microsoft Ubuntu instructions](https://learn.microsoft.com/powershell/scripting/install/install-ubuntu)
if absent. Keep Java security updates with its package manager. Install Workshop
in the actual WSL extension host if using a Remote WSL editor window; the normal
dotrepo `--install-tools` bootstrap already includes its extension ID.

The helper checks the release SHA256 before touching the installed files. It
copies the five matching Bib2Gls jars and three XML language resources into
the user `TEXMFHOME/scripts/bib2gls`, refreshes the user filename database, and
checks that the existing launcher selects that jar. Fira Code goes under
`$XDG_DATA_HOME/fonts/fira-code` (default `~/.local/share/fonts/fira-code`),
with Fontconfig and available LuaLaTeX caches refreshed. Replaced files are
backed up under `~/.dotrepo-backups/latex-<timestamp>/`; Windows font registry
values are backed up there too. Repeating installation preserves identical
files. `--archive /path/to/release.zip` supports an existing download with the
same mandatory hash check. Do this while the target has no active TeX build or
package update. It installs no LaTeX package or kernel files.

If an existing Ubuntu noble / TeX Live 2023 target lacks only `siunitx.sty`
and cannot use sudo, the tested user-local fallback uses the **matching**
`texlive-science=2023.20240207-1` package. Other Ubuntu/TeX releases should use
their matching package instead; do not apply this pin indiscriminately.

```bash
work=$(mktemp -d)
cd "$work"
apt-get download texlive-science=2023.20240207-1
printf '%s  %s\n' \
  01beac58521957fab75aeee6f07b8aacc2da94ef2c435b7fed719a5405d588d1 \
  texlive-science_2023.20240207-1_all.deb | sha256sum --check || exit 1
dpkg-deb --extract texlive-science_2023.20240207-1_all.deb extracted
texmf_home=$(kpsewhich --var-value=TEXMFHOME)
# Inspect an existing siunitx directory before replacing it.
test ! -e "$texmf_home/tex/latex/siunitx" || exit 1
mkdir -p "$texmf_home/tex/latex"
cp -a extracted/usr/share/texlive/texmf-dist/tex/latex/siunitx "$texmf_home/tex/latex/"
mktexlsr "$texmf_home"
kpsewhich siunitx.sty
```

This adds siunitx 3.3.10 and its four companion files only. Retain the downloaded
package privately for rollback/provenance. Remove a user override only after
checking that the distribution provides the intended replacement.

## Audit and thesis verification

Run `python scripts/latex-toolchain.py` (or `python3` inside WSL) for a read-only
font/hash, command-PATH, Bib2Gls-version, siunitx, and LaTeX-backend check. It
returns nonzero for missing or differing requirements. An older compatible tool
outside PATH may still be discovered by the thesis script; inspect the reported
item before installing a duplicate. Check editor versions with the commands
above and `java -version` in the selected build environment.

Open the target's thesis checkout and read its `docs/build/build.md`. Its
`thesis.tex` and include catalogs continue to own the thesis structure. Run:

```powershell
pwsh -NoProfile -File scripts/build.ps1 -Fast -Chapter ct-smpl-usecase -NoExternalize -OutDir BUILD/validation/focus
pwsh -NoProfile -File scripts/build.ps1 -Full -AllChapters -NoExternalize -OutDir BUILD/validation/all
pwsh -NoProfile -File scripts/build.ps1 -Full -IgnoreLocalBuildMode -NoExternalize
```

The last command leaves the tracked thesis assembly in canonical `BUILD`;
focused and all-catalog validation outputs remain in their separate directories.
Use a valid chapter ID from that checkout if `ct-smpl-usecase` has changed. The same
entry point runs inside WSL. LaTeX Workshop and VS Code tasks should use the
thesis repository's recipes, which route through this script and generate
`BUILD/thesis.pdf` plus plain `BUILD/thesis.synctex` using `-synctex=-1`.
Plain SyncTeX supports the tested SumatraPDF 3.6.1 installation: its forward
search failed with the large compressed thesis metadata and succeeded with
the same metadata uncompressed. The script removes obsolete plain and gzip
SyncTeX files in the selected output directory before each pass and requires
fresh plain output. Do not reproduce thesis style definitions or build recipes
in global editor settings.

For Windows Sumatra, use the thesis repository's
`scripts/vscode/open_sumatra.ps1` and inverse-search helper, and keep
the output PDF and `.synctex` together. Verify forward search to an edited
chapter and inverse search back to its correct file and line. For a Windows
editor using WSL compilation, use that repository's WSL recipe and viewer path
translation; verify the actual checkout paths on the target rather than copying
machine-specific settings. Serialize Windows and WSL builds of the same checkout.

Official assets: [Fira Code 6.2](https://github.com/tonsky/FiraCode/releases/tag/6.2),
[Bib2Gls 4.7](https://github.com/nlct/bib2gls/releases/tag/v4.7),
[SumatraPDF](https://www.sumatrapdfreader.org/download-free-pdf-viewer),
[LaTeX Workshop](https://github.com/James-Yu/LaTeX-Workshop/wiki/Install).
