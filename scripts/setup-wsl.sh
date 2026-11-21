#!/usr/bin/env bash
# Dev setup for Ubuntu on WSL2: installs the tools used in the prototype steps.
# Run inside WSL (not PowerShell): bash scripts/setup-wsl.sh
# Safe to re-run. Asks for your sudo password once.
set -euo pipefail

sudo apt update
sudo apt install -y \
  git tmux neovim build-essential curl unzip ripgrep \
  nodejs npm pipx python3-venv

# uv (Python package/project manager), via pipx so no installer script is piped to a shell.
pipx ensurepath
pipx install uv || pipx upgrade uv

# Let git in WSL reuse the Windows Git Credential Manager login.
git config --global credential.helper '/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe'

echo
echo "=== versions ==="
for t in git tmux nvim python3 uv node npm; do
  if command -v "$t" >/dev/null 2>&1; then
    printf '%-8s %s  (%s)\n' "$t" "$("$t" --version 2>&1 | head -1)" "$(command -v "$t")"
  else
    printf '%-8s MISSING\n' "$t"
  fi
done
echo
echo "node and npm should live under /usr/bin, not /mnt/c. Open a new shell if uv is missing."
