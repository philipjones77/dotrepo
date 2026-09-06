param(
    [ValidateSet('preserve', 'default', 'memory-32gb')][string]$WslProfile = 'preserve',
    [switch]$InstallTools
)
$ErrorActionPreference = "Stop"

$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$BackupRoot = Join-Path $HOME ".dotrepo-backups\$Timestamp"
$canonical = Join-Path $HOME '.dotrepo'
if (Test-Path -LiteralPath $canonical) {
    $item = Get-Item -LiteralPath $canonical -Force
    $actual = if ($item.Target) { [string](@($item.Target)[0]) } else { $item.FullName }
    if ([IO.Path]::GetFullPath($actual).TrimEnd('\') -ne $RepoRoot.TrimEnd('\')) {
        throw "Another checkout exists at $canonical. Run its bootstrap or relocate it explicitly first."
    }
} else {
    New-Item -ItemType Junction -Path $canonical -Target $RepoRoot | Out-Null
}

function Write-Log {
    param([string]$Message)
    Write-Host "[dotrepo] $Message"
}

function Backup-ItemPath {
    param([string]$Target)

    if (-not (Test-Path -LiteralPath $Target)) {
        return
    }

    $relative = $Target.TrimStart("\") -replace ":", ""
    $backupPath = Join-Path $BackupRoot $relative
    $backupDir = Split-Path $backupPath -Parent
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    $resolvedTarget = [IO.Path]::GetFullPath($Target)
    if (!$resolvedTarget.StartsWith($HOME.TrimEnd('\') + '\', [StringComparison]::OrdinalIgnoreCase)) {
        throw "Backup target is outside the user home: $Target"
    }
    Move-Item -LiteralPath $Target -Destination $backupPath -Force
    Write-Log "Backed up $Target -> $backupPath"
}

function Set-TrackedItem {
    param(
        [string]$Source,
        [string]$Target
    )

    $targetDir = Split-Path $Target -Parent
    $existing = Get-Item -LiteralPath $Target -Force -ErrorAction SilentlyContinue
    if ($existing -and $existing.LinkType -eq 'SymbolicLink' -and [string](@($existing.Target)[0]) -eq $Source) {
        Write-Log "Already linked $Target"
        return
    }
    if ($targetDir) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }

    Backup-ItemPath -Target $Target

    try {
        New-Item -ItemType SymbolicLink -Path $Target -Target $Source -Force | Out-Null
        Write-Log "Linked $Target"
    }
    catch {
        if (Test-Path $Source -PathType Container) {
            Copy-Item -Path $Source -Destination $Target -Recurse -Force
        }
        else {
            Copy-Item -Path $Source -Destination $Target -Force
        }

        Write-Log "Copied $Target (symlink unavailable)"
    }
}

function Install-VSCodeExtensions {
    param([string]$ExtensionsFile)

    $codeCmd = Join-Path $env:LOCALAPPDATA "Programs\Microsoft VS Code\bin\code.cmd"
    if (-not (Test-Path $codeCmd)) {
        Write-Log "Skipping Windows VS Code extension install; code.cmd was not found"
        return
    }

    Get-Content $ExtensionsFile | ForEach-Object {
        $extension = $_.Trim()
        if ($extension -and -not $extension.StartsWith("#")) {
            try {
                & $codeCmd --install-extension $extension --force | Out-Null
                if ($LASTEXITCODE -ne 0) { throw "Extension install failed: $extension" }
            }
            catch {
                throw
            }
        }
    }
}

$PowerShellProfileDir = Join-Path $HOME "Documents\PowerShell"
$GitConfigTarget = Join-Path $HOME ".gitconfig"
$SshDir = Join-Path $HOME ".ssh"
$SshConfigTarget = Join-Path $SshDir "config"
$WslConfigTarget = Join-Path $HOME ".wslconfig"
$CodeUserDir = Join-Path $env:APPDATA "Code\User"
$CodeSettingsTarget = Join-Path $CodeUserDir "settings.json"
$CodeKeybindingsTarget = Join-Path $CodeUserDir "keybindings.json"
$CodeSnippetsTarget = Join-Path $CodeUserDir "snippets"

$TerminalCandidates = @(
    (Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"),
    (Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json")
)
$TerminalTarget = $TerminalCandidates | Where-Object { Test-Path (Split-Path $_ -Parent) } | Select-Object -First 1
if (-not $TerminalTarget) {
    $TerminalTarget = $TerminalCandidates[0]
}

New-Item -ItemType Directory -Path $SshDir -Force | Out-Null
New-Item -ItemType Directory -Path $PowerShellProfileDir -Force | Out-Null

Set-TrackedItem -Source (Join-Path $RepoRoot "windows\powershell\Microsoft.PowerShell_profile.ps1") -Target (Join-Path $PowerShellProfileDir "Microsoft.PowerShell_profile.ps1")
Set-TrackedItem -Source (Join-Path $RepoRoot "windows\powershell\Microsoft.PowerShell_profile.ps1") -Target (Join-Path $HOME "Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1")
Set-TrackedItem -Source (Join-Path $RepoRoot "windows\terminal\settings.json") -Target $TerminalTarget
if ($WslProfile -ne 'preserve' -or !(Test-Path -LiteralPath $WslConfigTarget)) {
    $profileFile = if ($WslProfile -eq 'memory-32gb') { 'memory-32gb.wslconfig' } else { '.wslconfig' }
    Set-TrackedItem -Source (Join-Path $RepoRoot "windows\wsl\$profileFile") -Target $WslConfigTarget
}
Set-TrackedItem -Source (Join-Path $RepoRoot "git\gitconfig.windows") -Target $GitConfigTarget
Set-TrackedItem -Source (Join-Path $RepoRoot "ssh\config") -Target $SshConfigTarget
Set-TrackedItem -Source (Join-Path $RepoRoot "vscode\windows\settings.json") -Target $CodeSettingsTarget
Set-TrackedItem -Source (Join-Path $RepoRoot "vscode\keybindings.json") -Target $CodeKeybindingsTarget
Set-TrackedItem -Source (Join-Path $RepoRoot "vscode\snippets") -Target $CodeSnippetsTarget

if ($InstallTools) {
    Install-VSCodeExtensions -ExtensionsFile (Join-Path $RepoRoot "vscode\windows\extensions.txt")

if (Test-Path (Join-Path $RepoRoot "node\install-globals.ps1")) {
    & (Join-Path $RepoRoot "node\install-globals.ps1")
}
}

Write-Log "Windows bootstrap complete"
Write-Log "Next steps:"
Write-Log "  1. Restart PowerShell so the new profile loads"
Write-Log "  2. Run $HOME\.dotrepo\python\windows\create-venv.ps1 for a tracked venv"
Write-Log "  3. Run 'wsl --shutdown' from Windows for .wslconfig changes to take effect"
