#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
key="$HOME/.ssh/id_ed25519_github"
if [ ! -f "$key" ]; then
  ssh-keygen -t ed25519 -f "$key" -C "$(id -un)@$(hostname)"
fi
printf 'Register this public key at https://github.com/settings/keys (never the private key):\n'
cat "$key.pub"
printf 'Verify the GitHub host fingerprint, then run: ssh -T git@github.com\n'
