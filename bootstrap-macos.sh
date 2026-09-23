#!/usr/bin/env bash
# Installs Homebrew when needed, then the packages required by these dotfiles.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi
brew bundle --file="$DOTFILES_DIR/Brewfile"
"$DOTFILES_DIR/install.sh"
