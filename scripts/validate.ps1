$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path $PSScriptRoot -Parent
$failed = $false
foreach ($relative in (& git -C $repoRoot ls-files --cached --others --exclude-standard '*.ps1')) {
    $tokens = $null
    $parseErrors = $null
    [System.Management.Automation.Language.Parser]::ParseFile((Join-Path $repoRoot $relative), [ref]$tokens, [ref]$parseErrors) | Out-Null
    if ($parseErrors.Count) {
        $parseErrors | ForEach-Object { Write-Host "$relative : $_" }
        $failed = $true
    }
}
if ($failed) { throw 'PowerShell syntax validation failed.' }
Write-Host 'PowerShell syntax validation passed.'
