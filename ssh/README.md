# SSH

This repository tracks only the SSH client configuration.

Private keys are intentionally excluded. Add them manually:

1. Generate or copy a private key into `~/.ssh/`.
2. Create the matching public key if needed:
   `ssh-keygen -y -f ~/.ssh/id_ed25519_github > ~/.ssh/id_ed25519_github.pub`
3. Add the public key to GitHub.
4. Re-run the bootstrap script so `~/.ssh/config` points at the tracked template.
