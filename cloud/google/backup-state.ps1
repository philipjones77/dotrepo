$ErrorActionPreference = "Stop"

$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$BackupRoot = Join-Path $HOME ".local\share\dotrepo\google-reset\$Stamp"
New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null

function Test-CommandAvailable {
    param([string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Save-CommandOutput {
    param(
        [string]$Name,
        [string[]]$CommandArgs,
        [string]$OutputFile
    )

    if (-not (Test-CommandAvailable $Name)) {
        return
    }

    try {
        & $Name @CommandArgs 2>&1 | Out-File -FilePath (Join-Path $BackupRoot $OutputFile) -Encoding utf8
    }
    catch {
        $_ | Out-File -FilePath (Join-Path $BackupRoot $OutputFile) -Encoding utf8
    }
}

Save-CommandOutput -Name "gcloud" -CommandArgs @("info") -OutputFile "gcloud-info.txt"
Save-CommandOutput -Name "gcloud" -CommandArgs @("config", "configurations", "list") -OutputFile "gcloud-configurations.txt"
Save-CommandOutput -Name "gcloud" -CommandArgs @("auth", "list") -OutputFile "gcloud-auth-list.txt"

$GeminiDir = Join-Path $HOME ".gemini"
if (Test-Path -LiteralPath $GeminiDir) {
    Compress-Archive -Path $GeminiDir -DestinationPath (Join-Path $BackupRoot "gemini-state.zip") -Force
}

$GcloudConfigDir = Join-Path $env:APPDATA "gcloud"
if (Test-Path -LiteralPath $GcloudConfigDir) {
    Compress-Archive -Path $GcloudConfigDir -DestinationPath (Join-Path $BackupRoot "gcloud-config.zip") -Force
}

"# Google Tooling Backup"
""
"Created: $BackupRoot"
""
"This backup is local-only. Do not commit it."
