# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles repository for Linux systems. Config files are ready to use — clone the repo and create symlinks to your home directory.

### Key Files

- `.bashrc` — Bash shell config with bash-it framework (minimal theme)
- `.tmux.conf` — Tmux config with vim keybindings and Wayland/X11 clipboard auto-detection
- `.gitconfig` — Git configuration (credential helper: GitHub CLI, merge tool: vimdiff)
- `.npmrc` — NPM config (disables color/spinner/progress)
- `vimrc/` — Git submodule with complete Vim configuration (from github.com/FerchoRiveraR/vimrc)

### Setup

```bash
git clone --recursive https://github.com/FerchoRiveraR/dotfiles.git ~/dotfiles

ln -s ~/dotfiles/.bashrc ~/.bashrc
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/vimrc ~/.vim
ln -s ~/dotfiles/vimrc/vimrc ~/.vimrc
```

## Architecture

### Shell Initialization Order (`.bashrc`)

1. Standard bash setup (history, colors, completion)
2. bash-it framework (theme: minimal)
3. NVM (Node.js)
4. rbenv (Ruby)
5. pyenv (Python)

### Tmux Clipboard Integration

The `.tmux.conf` auto-detects the display server:
- **Wayland** (`$WAYLAND_DISPLAY` set): uses `wl-copy`
- **X11** (fallback): uses `xsel -i --clipboard`

Requires: `sudo apt install wl-clipboard xsel`

### Conditional Git Identity

`.gitconfig` uses `includeIf` to apply different user identity for work repos:
```ini
[includeIf "gitdir:~/WORK_DIR/"]
    path = ~/.gitconfig.work
```
Create `~/.gitconfig.work` manually and update `WORK_DIR` to your actual work directory path.

## Common Commands

```bash
# Reload shell config
source ~/.bashrc

# Reload tmux config (from inside tmux)
# prefix + r

# Update submodules
git submodule update --remote          # update all
git submodule update --remote vimrc    # update vimrc only
```

### Dependencies

```bash
# bash-it
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it && ~/.bash_it/install.sh

# NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# pyenv
curl https://pyenv.run | bash

# Clipboard tools (for tmux)
sudo apt install wl-clipboard xsel
```

## Git Commit Guidelines

- **Do NOT include** "Co-Authored-By: Claude Code" or similar co-author attributions
- Use **Conventional Commits** format: `type(scope): description`
  - Types: `feat`, `fix`, `docs`, `chore`, `refactor`, `style`, `test`
  - Example: `feat(tmux): add session management keybinding`
