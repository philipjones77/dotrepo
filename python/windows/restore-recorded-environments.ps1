<#
Reproduce recorded Windows package names/versions using uv-managed CPython.
Inventories are not artifact hash locks. Existing environments are never synced
or removed: reruns verify them, and require manual review of any mismatch.
#>
[CmdletBinding()]
param(
    [string]$InventoryDirectory = (Join-Path $PSScriptRoot '../../machines/source-2026-09-07/windows/standard-python'),
    [string]$EnvironmentRoot = (Join-Path $HOME '.virtualenvs'),
    [string]$ReportDirectory = (Join-Path $HOME '.local/share/dotrepo/windows-python'),
    [string[]]$EnvironmentName,
    [switch]$VerifyOnly
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
if ([Environment]::OSVersion.Platform -ne [PlatformID]::Win32NT) { throw 'Run this helper on Windows.' }
$uv = (Get-Command uv.exe -CommandType Application -ErrorAction Stop).Source
# The explicit system-trust policy must not inherit Conda's narrower CA bundle.
# Restore the caller's variables immediately after each uv process exits.
function Invoke-Uv {
    $certificateFile = $env:SSL_CERT_FILE
    $certificateDirectory = $env:SSL_CERT_DIR
    try {
        Remove-Item Env:SSL_CERT_FILE, Env:SSL_CERT_DIR -ErrorAction SilentlyContinue
        & $uv @args
        $script:UvExitCode = $LASTEXITCODE
    } finally {
        $env:SSL_CERT_FILE = $certificateFile
        $env:SSL_CERT_DIR = $certificateDirectory
    }
}
$InventoryDirectory = (Resolve-Path -LiteralPath $InventoryDirectory).Path
$EnvironmentRoot = [IO.Path]::GetFullPath($EnvironmentRoot)
$ReportDirectory = [IO.Path]::GetFullPath($ReportDirectory)
$inventory = @(Get-Content -LiteralPath (Join-Path $InventoryDirectory 'environments.json') -Raw | ConvertFrom-Json)
if ($EnvironmentName) {
    foreach ($name in $EnvironmentName) {
        if ($name -notin $inventory.name) { throw "Unknown environment: $name" }
    }
    $inventory = @($inventory | Where-Object name -In $EnvironmentName)
}
# Install the default last, so newly opened shells only select a complete default.
$inventory = @($inventory | Sort-Object @{Expression={ $_.name -eq 'py313' }}, name)
$plans = @()
foreach ($entry in $inventory) {
    if ($entry.name -notmatch '^[a-zA-Z0-9][a-zA-Z0-9_-]*$' -or $entry.python -notmatch '^3\.\d+\.\d+(?:(?:a|b|rc)\d+)?$') {
        throw 'Invalid interpreter or environment name in inventory.'
    }
    $packageFile = Join-Path $InventoryDirectory ($entry.name + '-packages.json')
    $packages = @(Get-Content -LiteralPath $packageFile -Raw | ConvertFrom-Json)
    $names = @{}
    foreach ($package in $packages) {
        if ($package.name -notmatch '^[a-zA-Z0-9][a-zA-Z0-9_.-]*$' -or $package.version -notmatch '^[a-zA-Z0-9][a-zA-Z0-9.!+_-]*$') {
            throw 'Invalid package name/version in inventory.'
        }
        $key = ($package.name -replace '[-_.]+', '-').ToLowerInvariant()
        if ($names.ContainsKey($key)) { throw "Duplicate package: $key" }
        $names[$key] = $true
    }
    if ($packages.Count -ne $entry.packages) { throw "Package count differs: $($entry.name)" }
    $plans += [pscustomobject]@{ Entry=$entry; File=$packageFile; Packages=$packages; Target=(Join-Path $EnvironmentRoot $entry.name) }
}
[IO.Directory]::CreateDirectory($ReportDirectory) | Out-Null
if (-not $VerifyOnly) {
    $versions = @($inventory.python | Sort-Object -Unique)
    Invoke-Uv python install @versions --no-bin --system-certs --no-progress
    if ($script:UvExitCode -ne 0) { throw 'CPython installation failed.' }
}
$results = @()
foreach ($plan in $plans) {
    $name = $plan.Entry.name
    $python = Join-Path $plan.Target 'Scripts/python.exe'
    $checkFile = Join-Path $ReportDirectory ($name + '-verification.json')
    $state = [ordered]@{Name=$name; Python=$plan.Entry.python; Path=$plan.Target; Passed=$false; Error=$null}
    try {
        if (-not (Test-Path -LiteralPath $plan.Target)) {
            if ($VerifyOnly) { throw 'Environment is absent.' }
            $requirements = Join-Path $ReportDirectory ($name + '-requirements.txt')
            @($plan.Packages | ForEach-Object { $_.name + '==' + $_.version }) |
                Set-Content -LiteralPath $requirements -Encoding ascii
            # Resolve against an empty private preflight venv. Never point pip sync
            # at a base interpreter, even in a dry run. Keep the preflight with the
            # report; the actual environment is created at its final path below.
            $preflight = Join-Path $ReportDirectory ('preflight-' + $name + '-' + [guid]::NewGuid().ToString('N'))
            Invoke-Uv venv --no-project --managed-python --python $plan.Entry.python --system-certs --no-progress $preflight
            if ($script:UvExitCode -ne 0) { throw 'Preflight environment creation failed.' }
            Invoke-Uv pip sync $requirements --python (Join-Path $preflight 'Scripts/python.exe') --dry-run --system-certs --default-index https://pypi.org/simple --no-progress
            if ($script:UvExitCode -ne 0) { throw 'Exact package dry-run failed.' }
            Invoke-Uv venv --no-project --managed-python --python $plan.Entry.python --system-certs --no-progress $plan.Target
            if ($script:UvExitCode -ne 0) { throw 'Environment creation failed.' }
            Invoke-Uv pip sync $requirements --python $python --strict --system-certs --default-index https://pypi.org/simple --no-progress
            if ($script:UvExitCode -ne 0) { throw 'Exact package installation failed; partial environment retained for review.' }
        }
        # Verification of an existing directory never changes its packages.
        if (-not (Test-Path -LiteralPath $python)) { throw 'Existing directory is not a usable environment.' }
        & $python (Join-Path $PSScriptRoot 'check-recorded-environment.py') --inventory $plan.File --python-version $plan.Entry.python --output $checkFile
        if ($LASTEXITCODE -ne 0) { throw 'Exact inventory or workload verification failed; inspect the report.' }
        $state.Passed = $true
    } catch {
        $state.Error = $_.Exception.Message
        Write-Warning "$name`: $($state.Error)"
    }
    $results += [pscustomobject]$state
    $results | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $ReportDirectory 'restore-results.json') -Encoding utf8
}
if (@($results | Where-Object { -not $_.Passed }).Count) { throw 'Some environments require review; see restore-results.json.' }
Write-Output 'All requested interpreter versions, package sets and workload checks match.'
