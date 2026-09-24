#requires -Version 7.0
[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 0)][string]$Pdf,
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$pdfPath = $Pdf
if ($pdfPath -match '^file:') {
    $pdfUri = [Uri]$pdfPath
    if (-not $pdfUri.IsFile) { throw 'Expected a local PDF file.' }
    $pdfPath = $pdfUri.LocalPath
}
if ($pdfPath -match '^/[A-Za-z]:[/\\]') { $pdfPath = $pdfPath.Substring(1) }
if ($pdfPath -match '^/mnt/([A-Za-z])/(.*)$') {
    $pdfPath = $Matches[1] + ':\' + $Matches[2].Replace('/', '\')
}
$pdfPath = (Resolve-Path -LiteralPath $pdfPath -ErrorAction Stop).ProviderPath
if ([IO.Path]::GetExtension($pdfPath) -ine '.pdf' -or -not (Test-Path -LiteralPath $pdfPath -PathType Leaf)) {
    throw "Expected an existing PDF: $pdfPath"
}
$candidates = @(
    (Join-Path $env:LOCALAPPDATA 'SumatraPDF\SumatraPDF.exe'),
    (Join-Path $env:ProgramFiles 'SumatraPDF\SumatraPDF.exe')
)
if (${env:ProgramFiles(x86)}) {
    $candidates += Join-Path ${env:ProgramFiles(x86)} 'SumatraPDF\SumatraPDF.exe'
}
$sumatraExe = $candidates | Where-Object { Test-Path -LiteralPath $_ -PathType Leaf } | Select-Object -First 1
if (-not $sumatraExe) { throw 'SumatraPDF is not installed in a standard location.' }
if ($DryRun) {
    [pscustomobject]@{ FileName = $sumatraExe; Arguments = @('-reuse-instance', $pdfPath) }
    return
}
$startInfo = [Diagnostics.ProcessStartInfo]::new()
$startInfo.FileName = $sumatraExe
$startInfo.UseShellExecute = $false
$startInfo.ArgumentList.Add('-reuse-instance')
$startInfo.ArgumentList.Add($pdfPath)
$viewer = [Diagnostics.Process]::Start($startInfo)
if (-not $viewer) { throw 'SumatraPDF did not start.' }
$viewer.Dispose()
