#requires -Version 7.0
[CmdletBinding()]
param(
    [string]$CodeCommand = (Join-Path $env:LOCALAPPDATA 'Programs\Microsoft VS Code\bin\code.cmd')
)
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$backupRoot = Join-Path $env:USERPROFILE ('.dotrepo-backups\' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '-sumatra-pdf')
New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
$backupIndex = 0
function Backup-File([string]$Target) {
    if (Test-Path -LiteralPath $Target) {
        $script:backupIndex++
        $backup = Join-Path $backupRoot ($script:backupIndex.ToString() + '-' + (Split-Path -Leaf $Target))
        Copy-Item -LiteralPath $Target -Destination $backup
        Add-Content -LiteralPath (Join-Path $backupRoot 'manifest.txt') -Value "$backup`t$Target"
    }
}

$opener = Join-Path $env:USERPROFILE '.local\bin\open-pdf.ps1'
Backup-File $opener
New-Item -ItemType Directory -Path (Split-Path -Parent $opener) -Force | Out-Null
Copy-Item -LiteralPath (Join-Path $repoRoot 'windows\open-pdf.ps1') -Destination $opener -Force
$body = (Get-Content -LiteralPath (Join-Path $repoRoot 'agents\pdf-opening.md') -Raw).Trim()
$block = "<!-- dotrepo-pdf-opening:start -->`n$body`n<!-- dotrepo-pdf-opening:end -->"
$instructionFiles = @(
    (Join-Path $env:USERPROFILE '.codex\AGENTS.md'),
    (Join-Path $env:USERPROFILE '.claude\CLAUDE.md'),
    (Join-Path $env:USERPROFILE '.gemini\GEMINI.md'),
    (Join-Path $env:USERPROFILE '.copilot\copilot-instructions.md'),
    (Join-Path $env:APPDATA 'Code\User\prompts\pdf-opening.instructions.md')
)
foreach ($target in $instructionFiles) {
    Backup-File $target
    New-Item -ItemType Directory -Path (Split-Path -Parent $target) -Force | Out-Null
    $existing = ''
    if (Test-Path -LiteralPath $target) { $existing = [IO.File]::ReadAllText($target) }
    if ($target.EndsWith('.instructions.md') -and [string]::IsNullOrWhiteSpace($existing)) {
        $existing = "---`ndescription: Open repository PDFs in SumatraPDF`napplyTo: '**'`n---`n"
    }
    if ($existing -match '(?s)<!-- dotrepo-pdf-opening:start -->.*?<!-- dotrepo-pdf-opening:end -->') {
        $updated = [regex]::Replace($existing, '(?s)<!-- dotrepo-pdf-opening:start -->.*?<!-- dotrepo-pdf-opening:end -->', [System.Text.RegularExpressions.MatchEvaluator]{ param($match) $block })
    } else { $updated = $existing.TrimEnd() + "`n`n" + $block + "`n" }
    Set-Content -LiteralPath $target -Value $updated.TrimStart() -Encoding utf8NoBOM
}
$package = Join-Path $repoRoot '.local\sumatra-pdf-1.0.0.vsix'
& python (Join-Path $repoRoot 'vscode\sumatra-pdf\package.py') $package
if ($LASTEXITCODE -ne 0) { throw 'Could not package the PDF routing extension.' }
& $CodeCommand --install-extension $package --force
if ($LASTEXITCODE -ne 0) { throw 'Could not install the PDF routing extension.' }
$settingsFile = Join-Path $env:APPDATA 'Code\User\settings.json'
Backup-File $settingsFile
$settings = Get-Content -LiteralPath $settingsFile -Raw | ConvertFrom-Json -AsHashtable
if (-not $settings.ContainsKey('workbench.editorAssociations')) { $settings['workbench.editorAssociations'] = @{} }
$settings['workbench.editorAssociations']['*.pdf'] = 'dotrepo.sumatraPdf'
$settings['latex-workshop.view.pdf.viewer'] = 'external'
$settings['latex-workshop.view.pdf.external.viewer.command'] = Join-Path $env:LOCALAPPDATA 'SumatraPDF\SumatraPDF.exe'
$settings['latex-workshop.view.pdf.external.viewer.args'] = @('-reuse-instance', '%PDF%')
$settings | ConvertTo-Json -Depth 50 | Set-Content -LiteralPath $settingsFile -Encoding utf8NoBOM
Write-Output "PDF opener, global instructions, and VS Code routing installed. Backups: $backupRoot"
Write-Output 'Reload existing VS Code windows to activate the routing extension. Windows .pdf default apps are managed separately in Settings.'
