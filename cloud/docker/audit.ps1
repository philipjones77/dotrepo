$ErrorActionPreference = "Stop"

function Test-CommandAvailable {
    param([string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Invoke-Optional {
    param(
        [string]$Name,
        [string[]]$CommandArgs
    )

    if (-not (Test-CommandAvailable $Name)) {
        return ""
    }

    try {
        return ((& $Name @CommandArgs 2>$null | Select-Object -First 1) -join " ").Trim()
    }
    catch {
        return "available but command failed"
    }
}

function Write-Check {
    param([string]$Name, [string]$Status, [string]$Detail = "")
    "| docker | $Name | $Status | $Detail |"
}

"# Docker Audit"
""
"Generated: $(Get-Date -Format s)"
""
"| Area | Check | Status | Detail |"
"| --- | --- | --- | --- |"

if (Test-CommandAvailable "docker") {
    Write-Check "docker cli" "ok" (Invoke-Optional -Name "docker" -CommandArgs @("--version"))
    Write-Check "docker compose" "manual-check" (Invoke-Optional -Name "docker" -CommandArgs @("compose", "version"))
    try {
        $info = & docker info --format "{{.ServerVersion}}" 2>$null
        Write-Check "docker daemon" "ok" "server $info"
    }
    catch {
        Write-Check "docker daemon" "missing" "docker cli exists, daemon unavailable"
    }
}
else {
    Write-Check "docker cli" "optional-missing" "Install Docker Desktop and enable WSL integration when container profiles require it"
}

if (Test-CommandAvailable "wsl") {
    Write-Check "wsl integration" "manual-check" "Run 'docker version' inside Ubuntu to verify WSL integration"
}
else {
    Write-Check "wsl integration" "not-applicable" "wsl command not found"
}
