$ErrorActionPreference = "Stop"

$StandardNodePath = Join-Path $HOME ".local\nodejs\current"
if (Test-Path -LiteralPath (Join-Path $StandardNodePath "node.exe")) {
    $env:Path = "$StandardNodePath;$env:Path"
    if (-not $env:NODE_USE_SYSTEM_CA) {
        $env:NODE_USE_SYSTEM_CA = "1"
    }
}

function Test-CommandAvailable {
    param([string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Write-Check {
    param([string]$Name, [string]$Status, [string]$Detail = "")
    "| google-cloud | $Name | $Status | $Detail |"
}

function Get-FirstLine {
    param([string]$Name, [string[]]$CommandArgs)
    if (-not (Test-CommandAvailable $Name)) {
        return ""
    }
    try {
        return ((& $Name @CommandArgs 2>$null | Select-Object -First 1) -join " ").Trim()
    }
    catch {
        return "available"
    }
}

$AntigravityCliPath = Join-Path $env:LOCALAPPDATA "agy\bin\agy.exe"
if (Test-Path -LiteralPath $AntigravityCliPath) {
    $env:Path = "$(Split-Path -Parent $AntigravityCliPath);$env:Path"
}

"# Google Tooling Audit"
""
"Generated: $(Get-Date -Format s)"
""
"| Area | Check | Status | Detail |"
"| --- | --- | --- | --- |"

if (-not (Test-CommandAvailable "gcloud")) {
    Write-Check "gcloud cli" "optional-missing" "Install Google Cloud CLI when Google Cloud profiles require it"
}
else {
    Write-Check "gcloud cli" "ok" (Get-FirstLine -Name "gcloud" -CommandArgs @("--version"))

    try {
        $sdkRoot = (& gcloud info --format="value(installation.sdk_root)" 2>$null).Trim()
        Write-Check "sdk root" "ok" $sdkRoot
    }
    catch {
        Write-Check "sdk root" "manual-check" "unable to read sdk root"
    }

    try {
        $account = (& gcloud config get-value account 2>$null).Trim()
        if ($account -and $account -ne "(unset)") {
            Write-Check "active account" "ok" "configured"
        }
        else {
            Write-Check "active account" "missing" "run gcloud auth login or application-default login"
        }
    }
    catch {
        Write-Check "active account" "missing" "unable to read gcloud account"
    }

    try {
        $project = (& gcloud config get-value project 2>$null).Trim()
        if ($project -and $project -ne "(unset)") {
            Write-Check "active project" "ok" $project
        }
        else {
            Write-Check "active project" "manual-check" "no default project configured"
        }
    }
    catch {
        Write-Check "active project" "manual-check" "unable to read gcloud project"
    }
}

if (Test-CommandAvailable "gemini") {
    Write-Check "gemini cli" "legacy" (Get-FirstLine -Name "gemini" -CommandArgs @("--version"))
}
else {
    Write-Check "gemini cli" "legacy-missing" "Use Antigravity CLI for individual/free Google AI coding workflows"
}

if (Test-CommandAvailable "agy") {
    Write-Check "antigravity cli" "ok" (Get-FirstLine -Name "agy" -CommandArgs @("--version"))
}
else {
    Write-Check "antigravity cli" "missing" "Run cloud/google/install-antigravity.ps1"
}

$AntigravityAppPath = Join-Path $env:LOCALAPPDATA "Programs\antigravity\Antigravity.exe"
if (Test-Path -LiteralPath $AntigravityAppPath) {
    try {
        Write-Check "antigravity app" "ok" ((& $AntigravityAppPath --version 2>$null | Select-Object -First 1) -join " ").Trim()
    }
    catch {
        Write-Check "antigravity app" "ok" $AntigravityAppPath
    }
}
else {
    Write-Check "antigravity app" "manual-check" "Install from https://antigravity.google/download when desktop workflows are used"
}

if (Test-CommandAvailable "npm") {
    Write-Check "npm" "ok" (Get-FirstLine -Name "npm" -CommandArgs @("--version"))
}
else {
    Write-Check "npm" "optional-missing" "Required for npm-managed Gemini CLI installs"
}

if (Test-Path -LiteralPath (Join-Path $StandardNodePath "node.exe")) {
    Write-Check "standard node path" "ok" $StandardNodePath
}

$GeminiDirs = @(
    (Join-Path $HOME ".gemini"),
    (Join-Path $HOME ".config\gemini")
)
foreach ($dir in $GeminiDirs) {
    if (Test-Path -LiteralPath $dir) {
        Write-Check "gemini state" "manual-check" $dir
    }
}
