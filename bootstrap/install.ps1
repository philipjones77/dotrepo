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

function Get-PowerShellProfilePaths {
    param([string]$DocumentsPath = [Environment]::GetFolderPath('MyDocuments'))

    if ([string]::IsNullOrWhiteSpace($DocumentsPath)) {
        throw 'Windows did not provide a Documents folder for PowerShell profiles.'
    }
    Join-Path $DocumentsPath 'PowerShell\Microsoft.PowerShell_profile.ps1'
    Join-Path $DocumentsPath 'WindowsPowerShell\Microsoft.PowerShell_profile.ps1'
    Join-Path $DocumentsPath 'PowerShell\Microsoft.VSCode_profile.ps1'
    Join-Path $DocumentsPath 'WindowsPowerShell\Microsoft.VSCode_profile.ps1'
}

function Read-JsonSettings {
    param([string]$Path)

    # Both applications accept JSON comments and trailing commas. Preserve quoted strings.
    $text = Get-Content -Raw -LiteralPath $Path
    $text = [regex]::Replace($text, '"(?:\\.|[^"\\])*"|//[^\r\n]*|/\*[\s\S]*?\*/', {
        param($match)
        if ($match.Value.StartsWith('"')) { $match.Value } else { ' ' }
    })
    $text = [regex]::Replace($text, '"(?:\\.|[^"\\])*"|,\s*(?=[}\]])', {
        param($match)
        if ($match.Value.StartsWith('"')) { $match.Value } else { '' }
    })
    $settings = $text | ConvertFrom-Json
    if ($settings -isnot [PSCustomObject]) {
        throw "Expected a JSON object in $Path"
    }
    return $settings
}

function Merge-JsonObject {
    param([PSCustomObject]$Existing, [PSCustomObject]$Tracked)

    foreach ($property in $Tracked.PSObject.Properties) {
        $current = $Existing.PSObject.Properties[$property.Name]
        $value = $property.Value
        if ($current -and $current.Value -is [PSCustomObject] -and $value -is [PSCustomObject]) {
            $value = Merge-JsonObject -Existing $current.Value -Tracked $value
        }
        $Existing | Add-Member -NotePropertyName $property.Name -NotePropertyValue $value -Force
    }
    return $Existing
}

function Merge-TerminalSettings {
    param([PSCustomObject]$Existing, [PSCustomObject]$Tracked)

    # Keep local shortcuts, colors, and other preferences; initialize missing keys only.
    foreach ($property in $Tracked.PSObject.Properties) {
        if ($property.Name -eq 'profiles') { continue }
        if ($property.Name -eq 'defaultProfile' -or -not $Existing.PSObject.Properties[$property.Name]) {
            $Existing | Add-Member -NotePropertyName $property.Name -NotePropertyValue $property.Value -Force
        }
    }
    if ($Tracked.profiles) {
        if (-not $Existing.profiles) {
            $Existing | Add-Member -NotePropertyName profiles -NotePropertyValue ([PSCustomObject]@{}) -Force
        }
        foreach ($property in $Tracked.profiles.PSObject.Properties) {
            if ($property.Name -ne 'list' -and -not $Existing.profiles.PSObject.Properties[$property.Name]) {
                $Existing.profiles | Add-Member -NotePropertyName $property.Name -NotePropertyValue $property.Value
            }
        }
        $profiles = @($Existing.profiles.list | Where-Object { $null -ne $_ })
        foreach ($profile in $Tracked.profiles.list) {
            $match = $profiles | Where-Object {
                if ($profile.guid) { $_.guid -eq $profile.guid }
                else { $_.name -eq $profile.name -and $_.source -eq $profile.source }
            } | Select-Object -First 1
            if ($match) {
                Merge-JsonObject -Existing $match -Tracked $profile | Out-Null
            } else {
                $profiles += $profile
            }
        }
        $Existing.profiles | Add-Member -NotePropertyName list -NotePropertyValue $profiles -Force
    }
    return $Existing
}

function Set-MergedJsonSettings {
    param([string]$Source, [string]$Target, [switch]$Terminal)

    # Parse and serialize before moving anything, so invalid settings stay untouched.
    $tracked = Read-JsonSettings -Path $Source
    $existingItem = Get-Item -LiteralPath $Target -Force -ErrorAction SilentlyContinue
    $existing = if ($existingItem) { Read-JsonSettings -Path $Target } else { [PSCustomObject]@{} }
    $before = $existing | ConvertTo-Json -Depth 100
    $merged = if ($Terminal) {
        Merge-TerminalSettings -Existing $existing -Tracked $tracked
    } else {
        Merge-JsonObject -Existing $existing -Tracked $tracked
    }
    $json = $merged | ConvertTo-Json -Depth 100
    if ($existingItem -and -not $existingItem.LinkType -and $before -ceq $json) {
        Write-Log "Settings already applied to $Target"
        return
    }
    New-Item -ItemType Directory -Path (Split-Path $Target -Parent) -Force | Out-Null
    Backup-ItemPath -Target $Target
    [IO.File]::WriteAllText($Target, $json.Replace("`r`n", "`n") + "`n", [Text.UTF8Encoding]::new($false))
    Write-Log "Merged tracked settings into $Target"
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

$PowerShellProfilePaths = @(Get-PowerShellProfilePaths)
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
foreach ($profilePath in $PowerShellProfilePaths) {
    Set-TrackedItem -Source (Join-Path $RepoRoot "windows\powershell\Microsoft.PowerShell_profile.ps1") -Target $profilePath
}
Set-MergedJsonSettings -Source (Join-Path $RepoRoot "windows\terminal\settings.json") -Target $TerminalTarget -Terminal
if ($WslProfile -ne 'preserve' -or !(Test-Path -LiteralPath $WslConfigTarget)) {
    $profileFile = if ($WslProfile -eq 'memory-32gb') { 'memory-32gb.wslconfig' } else { '.wslconfig' }
    Set-TrackedItem -Source (Join-Path $RepoRoot "windows\wsl\$profileFile") -Target $WslConfigTarget
}
Set-TrackedItem -Source (Join-Path $RepoRoot "git\gitconfig.windows") -Target $GitConfigTarget
Set-TrackedItem -Source (Join-Path $RepoRoot "ssh\config") -Target $SshConfigTarget
Set-MergedJsonSettings -Source (Join-Path $RepoRoot "vscode\windows\settings.json") -Target $CodeSettingsTarget
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
