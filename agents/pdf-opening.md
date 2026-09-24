# PDF opening preference

Use SumatraPDF for every repository's PDFs on this Windows computer.
When delivering a generated or revised PDF, open it directly in SumatraPDF once
the requested work is complete; a chat file link alone is not enough.
Keep clickable file links for locating the artifact, but do not claim that a chat
link determines the viewer used by every application.

From PowerShell, use the repository-independent opener:

```powershell
& "$env:USERPROFILE\.local\bin\open-pdf.ps1" -Pdf 'C:\absolute\path\document.pdf'
```

For a WSL file, pass its Windows UNC path
(`\\wsl.localhost\Ubuntu\home\phili\...\document.pdf`) to that Windows opener.
From WSL Bash, use `~/.local/bin/open-pdf /absolute/path/document.pdf`; this
converts the path and invokes the same Windows opener.
Open the actual PDF, not its LaTeX source or its raw text in an editor.
Preserve LaTeX Workshop and repository-specific SyncTeX commands.
If local launch access is unavailable, say so; do not claim the viewer was opened.
