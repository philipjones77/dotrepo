# SSH on every machine

Windows and WSL use SSH for GitHub Git operations, with independent keys and optional separate Git identities. Run `ssh/setup.ps1` in Windows or `bash ssh/setup.sh` in WSL. Each generates `~/.ssh/id_ed25519_github` only if absent, prompts for a passphrase, and prints the public key. Register it in the intended GitHub account. Never commit or upload the private key.

Run bootstrap to install the client configuration, verify GitHub's published host fingerprint on first connection, then run `ssh -T git@github.com`. GitHub prints a successful authentication greeting but normally returns exit 1 because it provides no shell. Use `scripts/doctor.py --network` for an exit-code-based repository access check.

The shared Git configuration rewrites GitHub HTTPS Git URLs to SSH. Existing explicit remotes can also be changed with `git remote set-url origin git@github.com:OWNER/REPO.git`. GitHub APIs and Actions tokens remain separate from Git SSH access.

Store extra host aliases or identity-file overrides in `~/.ssh/config.local`, and personal Git name/email overrides in `~/.gitconfig.local`. Use a separate alias and key for a different GitHub account. The tracked `github-personal` alias uses this platform's default GitHub key.

Passphrase keys can be loaded into a native SSH agent with `ssh-add ~/.ssh/id_ed25519_github`. Agent setup depends on the OS/session; the scripts do not enable system services or remove passphrases automatically.

References: [GitHub SSH setup](https://docs.github.com/en/authentication/connecting-to-github-with-ssh), [GitHub host fingerprints](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints).
