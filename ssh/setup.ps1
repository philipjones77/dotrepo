$ErrorActionPreference = 'Stop'
$sshDir = Join-Path $HOME '.ssh'
New-Item -ItemType Directory -Path $sshDir -Force | Out-Null
$key = Join-Path $sshDir 'id_ed25519_github'
if (!(Test-Path -LiteralPath $key)) {
    & ssh-keygen -t ed25519 -f $key -C "$env:USERNAME@$env:COMPUTERNAME"
    if ($LASTEXITCODE -ne 0) { throw 'SSH key generation failed.' }
}
Write-Host 'Register this public key at https://github.com/settings/keys (never the private key):'
Get-Content -LiteralPath "$key.pub"
Write-Host 'Verify the GitHub host fingerprint, then run: ssh -T git@github.com'
