# dotFile

Portable macOS terminal preferences:

- iTerm2 preferences
- tmux and its status line
- zsh / Oh My Zsh configuration
- Homebrew dependency list

SSH keys, access tokens, shell history, and Git identity are deliberately excluded.

## New Mac setup

```bash
git clone git@github.com:wrong-mistake/dotFile.git ~/dotFile
cd ~/dotFile
./bootstrap-macos.sh
```

If Homebrew is already present and you only want to link configurations:

```bash
./install.sh
brew bundle --file=./Brewfile
```

Restart iTerm2 after installation so it loads the repository-managed preferences.

## Updating

After changing local iTerm2, tmux, or zsh settings, export the relevant change into this repository, review it, then commit and push. Never commit private keys, tokens, or `.zsh_history`.
