#requires -Version 5.1
<#
.SYNOPSIS
Open a Windows desktop through an existing, verified LAN SSH alias.
.DESCRIPTION
Requires TightVNC Viewer and an SSH key/known-host entry already configured.
The private JSON file defaults to LOCALAPPDATA\dotrepo\lan-desktop\connection.json:
  PeerAlias: the destination's SSH alias (no address or credentials here)
  LocalPort: 0 for an available ephemeral loopback port, or an explicit port
  ViewerPath: optional path to tvnviewer.exe
TightVNC prompts for the destination's existing VNC password. This launcher
does not read, store or change passwords. Keep machine-local configuration off Git.
.EXAMPLE
& .\windows\open-lan-desktop.ps1
#>
[CmdletBinding()]
param(
    [string]$ConfigPath = (Join-Path $env:LOCALAPPDATA 'dotrepo\lan-desktop\connection.json')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-DesktopLocalPort {
    param([int]$RequestedPort)
    if ($RequestedPort -lt 0 -or $RequestedPort -gt 65535) {
        throw 'LocalPort must be 0 (automatic) or a TCP port from 1 to 65535.'
    }
    $listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $RequestedPort)
    $listener.Server.ExclusiveAddressUse = $true
    try {
        $listener.Start()
        return $listener.LocalEndpoint.Port
    }
    finally { $listener.Stop() }
}

function Test-DesktopRfbGreeting {
    param([int]$Port)
    $client = [System.Net.Sockets.TcpClient]::new()
    try {
        $connect = $client.ConnectAsync('127.0.0.1', $Port)
        if (-not $connect.Wait(500)) { return $false }
        $stream = $client.GetStream()
        $stream.ReadTimeout = 1000
        $buffer = [byte[]]::new(12)
        $received = 0
        while ($received -lt $buffer.Length) {
            $count = $stream.Read($buffer, $received, $buffer.Length - $received)
            if ($count -eq 0) { return $false }
            $received += $count
        }
        return [System.Text.Encoding]::ASCII.GetString($buffer) -match '^RFB 003\.\d{3}\n$'
    }
    catch { return $false }
    finally { $client.Dispose() }
}

$tunnel = $null
$viewer = $null
$failure = $null

try {
    if (-not (Test-Path -LiteralPath $ConfigPath -PathType Leaf)) {
        throw "Private desktop configuration is missing: $ConfigPath. Complete LAN desktop setup on this computer first."
    }
    $config = Get-Content -LiteralPath $ConfigPath -Raw | ConvertFrom-Json
    if ([string]$config.PeerAlias -notmatch '^[A-Za-z0-9][A-Za-z0-9_.-]*$') {
        throw 'PeerAlias must be a single SSH configuration alias, without spaces or options.'
    }
    $peerAlias = [string]$config.PeerAlias
    $viewerPath = Join-Path $env:ProgramFiles 'TightVNC\tvnviewer.exe'
    if ($config.PSObject.Properties['ViewerPath'] -and $config.ViewerPath) {
        $viewerPath = [Environment]::ExpandEnvironmentVariables([string]$config.ViewerPath)
    }
    if (-not (Test-Path -LiteralPath $viewerPath -PathType Leaf)) {
        throw "TightVNC Viewer was not found at $viewerPath. Install its Viewer component first."
    }
    $sshPath = Join-Path $env:WINDIR 'System32\OpenSSH\ssh.exe'
    if (-not (Test-Path -LiteralPath $sshPath -PathType Leaf)) {
        $sshPath = (Get-Command ssh.exe -CommandType Application -ErrorAction Stop | Select-Object -First 1).Source
    }
    $requestedPort = 0
    if ($config.PSObject.Properties['LocalPort']) { $requestedPort = [int]$config.LocalPort }
    $localPort = Get-DesktopLocalPort -RequestedPort $requestedPort

    $sshInfo = [System.Diagnostics.ProcessStartInfo]::new()
    $sshInfo.FileName = $sshPath
    $sshInfo.Arguments = '-N -T -o BatchMode=yes -o StrictHostKeyChecking=yes -o ExitOnForwardFailure=yes ' +
        '-o ConnectTimeout=10 -o ServerAliveInterval=15 -o ServerAliveCountMax=2 -o ForwardAgent=no ' +
        '-o ControlMaster=no -o ControlPath=none -L 127.0.0.1:' + $localPort + ':127.0.0.1:5900 ' + $peerAlias
    $sshInfo.UseShellExecute = $false
    $sshInfo.CreateNoWindow = $true
    $sshInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
    $sshInfo.RedirectStandardError = $true
    $tunnel = [System.Diagnostics.Process]::Start($sshInfo)
    $sshErrors = $tunnel.StandardError.ReadToEndAsync()
    $deadline = [DateTime]::UtcNow.AddSeconds(20)
    $ready = $false
    do {
        if ($tunnel.HasExited) {
            throw "SSH could not open the desktop tunnel to $peerAlias. $($sshErrors.GetAwaiter().GetResult().Trim()) Try: ssh $peerAlias hostname"
        }
        $ownedListener = Get-NetTCPConnection -LocalAddress 127.0.0.1 -LocalPort $localPort -State Listen -ErrorAction SilentlyContinue |
            Where-Object OwningProcess -eq $tunnel.Id
        $ready = $ownedListener -and (Test-DesktopRfbGreeting -Port $localPort)
        if (-not $ready) { Start-Sleep -Milliseconds 200 }
    } until ($ready -or [DateTime]::UtcNow -ge $deadline)
    if (-not $ready) {
        throw "The desktop on $peerAlias did not respond within 20 seconds. Check that the PC is awake, SSH works, and its TightVNC service is running on loopback port 5900."
    }
    # Keep the viewer tied to the tunnel process that owns this listening port.
    if ($tunnel.HasExited) { throw 'The SSH tunnel closed before the viewer could start. Try again.' }

    $viewerInfo = [System.Diagnostics.ProcessStartInfo]::new()
    $viewerInfo.FileName = $viewerPath
    # TightVNC 2.8.88 ViewerCmdLine.cpp accepts host::port and maps scale=auto
    # to fitWindow(true). Omitting its password option leaves authentication
    # to the viewer's password dialog.
    $viewerInfo.Arguments = '127.0.0.1::' + $localPort + ' -scale=auto'
    $viewerInfo.UseShellExecute = $false
    $viewerInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Normal
    $viewer = [System.Diagnostics.Process]::Start($viewerInfo)
    while (-not $viewer.WaitForExit(500)) {
        if ($tunnel.HasExited) {
            throw "SSH disconnected from $peerAlias. Check its power and LAN connection, then reopen the desktop shortcut."
        }
    }
    if ($viewer.ExitCode -ne 0) { throw "TightVNC Viewer exited with code $($viewer.ExitCode). Check the remote VNC service and enter its existing VNC password." }
}
catch {
    $failure = $_
}
finally {
    foreach ($ownedProcess in @($viewer, $tunnel)) {
        if ($null -ne $ownedProcess) {
            try {
                if (-not $ownedProcess.HasExited) {
                    $ownedProcess.Kill()
                    $null = $ownedProcess.WaitForExit(3000)
                }
            }
            catch { Write-Warning ('Could not close a desktop helper: ' + $_.Exception.Message) }
            finally { $ownedProcess.Dispose() }
        }
    }
}

# Release the connection before a modal error dialog can pause this script.
if ($null -ne $failure) {
    if ([Environment]::UserInteractive) {
        try {
            Add-Type -AssemblyName System.Windows.Forms
            $null = [System.Windows.Forms.MessageBox]::Show(
                $failure.Exception.Message, 'LAN desktop connection', 'OK', 'Error')
        }
        catch { } # Preserve the original connection error if no desktop is available.
    }
    $PSCmdlet.ThrowTerminatingError($failure)
}
