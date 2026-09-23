#!/usr/bin/env bash
# Install the tracked terminal configuration. Safe to run repeatedly.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
backup_dir="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

backup_if_needed() {
  local target="$1"
  if [[ -e "$target" && ! -L "$target" ]]; then
    mkdir -p "$backup_dir"
    mv "$target" "$backup_dir/$(basename "$target")"
    printf 'Backed up %s to %s\n' "$target" "$backup_dir"
  fi
}

link_file() {
  local source="$1" target="$2"
  backup_if_needed "$target"
  ln -sfn "$source" "$target"
}

append_once() {
  local file="$1" line="$2"
  touch "$file"
  grep -qxF "$line" "$file" || printf '\n%s\n' "$line" >> "$file"
}

link_file "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
link_file "$DOTFILES_DIR/tmux/tmuxline.conf" "$HOME/.tmuxline.conf"
append_once "$HOME/.zshrc" "source \"$DOTFILES_DIR/zsh/zshrc\""

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi
if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git \
    "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
fi
if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
fi

if [[ "$(uname)" == "Darwin" ]]; then
  defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES_DIR/iterm2"
  defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
  defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile_selection -int 2
fi

printf '\nInstalled dotfiles from %s\n' "$DOTFILES_DIR"
printf 'Restart iTerm2 and open a new shell. For packages: brew bundle --file=%s/Brewfile\n' "$DOTFILES_DIR"
