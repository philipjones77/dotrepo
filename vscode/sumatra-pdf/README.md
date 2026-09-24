# SumatraPDF for repository PDFs

This local Windows VS Code extension opens PDF tabs in the installed SumatraPDF.
It supports local files and Windows-accessible WSL files, and uses argument
arrays without a shell. It leaves other file types, diff tabs, dirty editors,
and already open tabs alone. Newly opened PDF tabs are closed only after the
viewer process starts. LaTeX Workshop remains installed for LaTeX and SyncTeX.

Use `dotrepo.sumatraPdf` for the `*.pdf` editor association. The public tab API
also catches chat extensions that explicitly request a PDF as a text editor.
The extension runs on the Windows UI host, including in WSL remote windows.
SSH and container PDFs without a Windows-accessible path are not redirected.

The extension does not change Windows default apps or web chat/browser viewers.
Windows Settings must associate `.pdf` with SumatraPDF for other applications
that use the system file association. Global agent instructions provide the
direct opener when the chat client controls file links itself.
