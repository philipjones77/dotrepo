param([string]$FileList)
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path $PSScriptRoot -Parent
$failed = $false
if ($FileList) {
    $paths = Get-Content -LiteralPath $FileList -Raw | ConvertFrom-Json
} else {
    $relativePaths = @(& git -C $repoRoot ls-files --cached --others --exclude-standard '*.ps1')
    if ($LASTEXITCODE -ne 0) { throw 'Git could not enumerate PowerShell files.' }
    $paths = @($relativePaths | ForEach-Object { Join-Path $repoRoot $_ })
}
foreach ($path in $paths) {
    $tokens = $null
    $parseErrors = $null
    [System.Management.Automation.Language.Parser]::ParseFile($path, [ref]$tokens, [ref]$parseErrors) | Out-Null
    if ($parseErrors.Count) {
        $parseErrors | ForEach-Object { Write-Host "$path : $_" }
        $failed = $true
    }
}
if ($failed) { throw 'PowerShell syntax validation failed.' }
Write-Host 'PowerShell syntax validation passed.'
