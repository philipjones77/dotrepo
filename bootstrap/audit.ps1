$ErrorActionPreference = "Stop"

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
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

function Get-CommandVersion {
    param(
        [string]$Name,
        [string[]]$VersionArgs = @("--version")
    )

    if (-not (Test-CommandAvailable $Name)) {
        return ""
    }

    try {
        $output = & $Name @VersionArgs 2>$null | Select-Object -First 1
        return ((($output | Select-Object -First 1) -join " ") -replace "`0", "").Trim()
    }
    catch {
        return "available"
    }
}

function Get-PathStatus {
    param([string]$Path)

    if (Test-Path -LiteralPath $Path) {
        $item = Get-Item -LiteralPath $Path -Force
        if ($item.LinkType) {
            return "ok symlink"
        }
        return "ok exists"
    }

    return "missing"
}

function Write-Check {
    param(
        [string]$Area,
        [string]$Name,
        [string]$Status,
        [string]$Detail = ""
    )

    "| $Area | $Name | $Status | $Detail |"
}

$PowerShellProfile = Join-Path $HOME "Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
$CodeSettings = Join-Path $env:APPDATA "Code\User\settings.json"
$TerminalSettings = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

"# dotrepo Windows Audit"
""
"Generated: $(Get-Date -Format s)"
"Repo: $RepoRoot"
""
"| Area | Check | Status | Detail |"
"| --- | --- | --- | --- |"

Write-Check "core" "git" ($(if (Test-CommandAvailable "git") { "ok" } else { "missing" })) (Get-CommandVersion -Name "git" -VersionArgs @("--version"))
Write-Check "core" "gh" ($(if (Test-CommandAvailable "gh") { "ok" } else { "missing" })) (Get-CommandVersion -Name "gh" -VersionArgs @("--version"))
Write-Check "core" "wsl" ($(if (Test-CommandAvailable "wsl") { "ok" } else { "missing" })) (Get-CommandVersion -Name "wsl" -VersionArgs @("--version"))
Write-Check "editor" "code" ($(if (Test-CommandAvailable "code") { "ok" } else { "optional-missing" })) (Get-CommandVersion -Name "code" -VersionArgs @("--version"))
Write-Check "python" "python" ($(if (Test-CommandAvailable "python") { "ok" } else { "missing" })) (Get-CommandVersion -Name "python" -VersionArgs @("--version"))
Write-Check "python" "conda" ($(if (Test-CommandAvailable "conda") { "ok" } else { "optional-missing" })) (Get-CommandVersion -Name "conda" -VersionArgs @("--version"))
Write-Check "python" "mamba" ($(if (Test-CommandAvailable "mamba") { "ok" } else { "optional-missing" })) (Get-CommandVersion -Name "mamba" -VersionArgs @("--version"))
Write-Check "node" "node" ($(if (Test-CommandAvailable "node") { "ok" } else { "optional-missing" })) (Get-CommandVersion -Name "node" -VersionArgs @("--version"))
Write-Check "node" "npm" ($(if (Test-CommandAvailable "npm") { "ok" } else { "optional-missing" })) (Get-CommandVersion -Name "npm" -VersionArgs @("--version"))
Write-Check "container" "docker" ($(if (Test-CommandAvailable "docker") { "ok" } else { "optional-missing" })) (Get-CommandVersion -Name "docker" -VersionArgs @("--version"))
Write-Check "cloud" "gcloud" ($(if (Test-CommandAvailable "gcloud") { "ok" } else { "optional-missing" })) (Get-CommandVersion -Name "gcloud" -VersionArgs @("--version"))

Write-Check "dotfiles" "$HOME\.gitconfig" (Get-PathStatus (Join-Path $HOME ".gitconfig"))
Write-Check "dotfiles" "$HOME\.ssh\config" (Get-PathStatus (Join-Path $HOME ".ssh\config"))
Write-Check "dotfiles" "PowerShell profile" (Get-PathStatus $PowerShellProfile)
Write-Check "dotfiles" "VS Code settings" (Get-PathStatus $CodeSettings)
Write-Check "dotfiles" "Windows Terminal settings" (Get-PathStatus $TerminalSettings)
Write-Check "dotfiles" "$HOME\.wslconfig" (Get-PathStatus (Join-Path $HOME ".wslconfig"))
