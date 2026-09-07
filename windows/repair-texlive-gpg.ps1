# Use TeX Live's native Windows verifier without changing Git's GPG selection.
[CmdletBinding()]
param([string]$TeXRoot='C:\texlive\2026')
$ErrorActionPreference='Stop'
Set-StrictMode -Version Latest
$TeXRoot=(Resolve-Path -LiteralPath $TeXRoot).Path
if($TeXRoot -match '[%"\r\n]|[^\x20-\x7e]'){throw 'Use an ASCII TeX root without quotes or percent signs for the Windows command wrapper.'}
$gpg=Join-Path $TeXRoot 'tlpkg\installer\gpg\gpg.exe'
$perl=Join-Path $TeXRoot 'tlpkg\tlperl\bin\perl.exe'
foreach($file in @($gpg,$perl,(Join-Path $TeXRoot 'tlpkg\TeXLive\TLCrypto.pm'))){
    if(-not (Test-Path -LiteralPath $file -PathType Leaf)){
        throw ('Required TeX Live file missing: '+$file+'. Install TeX Live and its official tlgpg package first; see the Windows parity report.')
    }
}
$bin=Join-Path $env:USERPROFILE '.local\bin'
[IO.Directory]::CreateDirectory($bin)|Out-Null
$shim=Join-Path $bin 'texlive-gpg.cmd'
$content="@echo off`r`n`"$gpg`" %*`r`nexit /b %errorlevel%`r`n"
$oldShim=if(Test-Path -LiteralPath $shim){[IO.File]::ReadAllBytes($shim)}else{$null}
$backup=Join-Path $env:USERPROFILE ('.dotrepo-backups\'+(Get-Date -Format 'yyyyMMdd-HHmmssfff')+'-texlive-gpg')
[IO.Directory]::CreateDirectory($backup)|Out-Null
$oldUserPath=[Environment]::GetEnvironmentVariable('Path','User')
$oldUserGpg=[Environment]::GetEnvironmentVariable('TL_GNUPG','User')
if($null -ne $oldShim){[IO.File]::WriteAllBytes((Join-Path $backup 'texlive-gpg.cmd'),$oldShim)}
[ordered]@{Time=(Get-Date).ToString('o');Path=$oldUserPath;TL_GNUPG=$oldUserGpg;ShimExisted=($null -ne $oldShim)}|ConvertTo-Json|Set-Content (Join-Path $backup 'before.json')
$priorPath=$env:PATH;$priorGpg=$env:TL_GNUPG
$probe=Join-Path $backup 'verify-native-gpg.pl'
$success=$false
try {
    [IO.File]::WriteAllText($shim,$content,[Text.ASCIIEncoding]::new())
    $env:PATH=$bin+';'+[Environment]::GetEnvironmentVariable('Path','Machine')+';'+$oldUserPath
    $env:TL_GNUPG='texlive-gpg'
    $program=@'
use strict;
use warnings;
use TeXLive::TLUtils;
use TeXLive::TLCrypto;
my $root = shift @ARGV;
TeXLive::TLCrypto::setup_gpg($root) or die "Native verifier discovery failed\n";
print "TEXLIVE_GPG_COMMAND=$::gpg\n";
my $code = system("$::gpg --list-keys");
die "TeX Live keyring check failed\n" if $code != 0;
print "TEXLIVE_NATIVE_GPG_KEYRING_PASS\n";
'@
    [IO.File]::WriteAllText($probe,$program,[Text.UTF8Encoding]::new($false))
    $output=@(& $perl ('-I'+(Join-Path $TeXRoot 'tlpkg')) $probe $TeXRoot 2>&1)
    $code=$LASTEXITCODE
    $output|Set-Content (Join-Path $backup 'verification.log')
    if($code -ne 0 -or ($output -join "`n") -notmatch 'TEXLIVE_NATIVE_GPG_KEYRING_PASS'){throw 'Native TeX verifier failed; see the backup verification log.'}
    $parts=@($oldUserPath -split ';'|Where-Object {$_})
    if($bin -notin $parts){[Environment]::SetEnvironmentVariable('Path',(($parts+$bin)-join ';'),'User')}
    # TeX Live's Windows program lookup accepts a basename, not an absolute path.
    [Environment]::SetEnvironmentVariable('TL_GNUPG','texlive-gpg','User')
    $success=$true
    [ordered]@{TeXRoot=$TeXRoot;Wrapper=$shim;TL_GNUPG='texlive-gpg';KeyringVerified=$true;Backup=$backup;NewTerminalRequired=$true}|ConvertTo-Json
}finally{
    $env:PATH=$priorPath
    if($null -eq $priorGpg){Remove-Item Env:TL_GNUPG -ErrorAction SilentlyContinue}else{$env:TL_GNUPG=$priorGpg}
    if(-not $success){
        if($null -eq $oldShim){Remove-Item -LiteralPath $shim -ErrorAction SilentlyContinue}else{[IO.File]::WriteAllBytes($shim,$oldShim)}
        [Environment]::SetEnvironmentVariable('Path',$oldUserPath,'User')
        [Environment]::SetEnvironmentVariable('TL_GNUPG',$oldUserGpg,'User')
    }
}
