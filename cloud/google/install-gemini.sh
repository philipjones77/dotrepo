#!/usr/bin/env bash
set -euo pipefail

env_name="${DOTREPO_GEMINI_CONDA_ENV:-gemini-cli}"
package="${DOTREPO_GEMINI_NPM_PACKAGE:-@google/gemini-cli@latest}"
conda_root="${CONDA_EXE:-}"

if [ -n "$conda_root" ]; then
  conda_root="$(dirname "$(dirname "$conda_root")")"
elif [ -d "$HOME/miniforge3" ]; then
  conda_root="$HOME/miniforge3"
elif [ -d "$HOME/anaconda3" ]; then
  conda_root="$HOME/anaconda3"
else
  echo "conda/miniforge was not found" >&2
  exit 1
fi

# shellcheck disable=SC1091
. "$conda_root/etc/profile.d/conda.sh"

if ! conda env list | awk '{print $1}' | grep -qx "$env_name"; then
  if command -v mamba >/dev/null 2>&1; then
    mamba create -y -n "$env_name" -c conda-forge 'nodejs>=20'
  else
    conda create -y -n "$env_name" -c conda-forge 'nodejs>=20'
  fi
fi

conda activate "$env_name"
export PATH="$CONDA_PREFIX/bin:$PATH"
node --version
npm --version
npm install -g --allow-scripts=@github/keytar,node-pty "$package"
gemini --version

mkdir -p "$HOME/.local/bin"
cat > "$HOME/.local/bin/gemini" <<EOF
#!/usr/bin/env bash
set -euo pipefail
. "$conda_root/etc/profile.d/conda.sh"
conda activate "$env_name"
export PATH="\$CONDA_PREFIX/bin:\$PATH"
exec "$conda_root/envs/$env_name/bin/gemini" "\$@"
EOF
chmod +x "$HOME/.local/bin/gemini"

echo "Installed Gemini CLI wrapper at $HOME/.local/bin/gemini"
