# Fernando's dotfiles

Personal dotfiles for Linux systems, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

| Package | Description |
|---------|-------------|
| `bash` | Bash shell config with bash-it framework |
| `git` | Git configuration (GitHub CLI, vimdiff) |
| `npm` | NPM config |
| `tmux` | Tmux with vim keybindings and clipboard integration |
| `vim` | Vim configuration (git submodule) |

## Setup

```bash
# Install stow
sudo pacman -S stow

# Clone with submodules
git clone --recursive https://github.com/FerchoRiveraR/dotfiles.git ~/dotfiles

# Stow all packages
cd ~/dotfiles
stow -t ~ bash git npm tmux vim

# Or pick only what you need
stow -t ~ bash git tmux
```

## Uninstall

```bash
cd ~/dotfiles
stow -t ~ -D bash git npm tmux vim
```

See [CLAUDE.md](CLAUDE.md) for detailed documentation and dependency setup.
