# GitHub environment and workflows

This repository manages its own workflow definitions and provides conventions for other repositories. It does not currently modify account settings, organization policies, branch protection, environments, or other repositories remotely.

`Validate` runs on pushes, pull requests and manual dispatch. Its Windows and Ubuntu matrix invokes `scripts/validate.py` and `tests/`. Each job has a timeout, only `contents: read`, and checkout credentials are not persisted. Action references use full commit SHAs. Dependabot proposes Action and validation-tool updates for review.

Local Windows/WSL Git access uses SSH. Hosted Actions use the short-lived GitHub token for checkout; personal workstation SSH keys are not installed on runners. GitHub CLI API access also uses an API token independently of Git transport. If a future workflow needs an external SSH service, use a dedicated restricted credential and environment-specific secret.

Recommended repository rule: require pull requests and both `validate (ubuntu-latest)` and `validate (windows-latest)` checks before merging. Configure that rule in GitHub settings after the workflow has run; adding YAML alone does not enforce branch protection.

For other projects, reuse the validation pattern and add their real build/test commands. A syntax check does not validate Python/R/MATLAB scientific results, deployment credentials, or hardware compatibility. Name the repositories before applying remote changes across an account.

Sources: [GitHub secure workflow use](https://docs.github.com/en/actions/reference/security/secure-use), [checkout action](https://github.com/actions/checkout).
