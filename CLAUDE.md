# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for managing shell configurations and development environment setup for Linux Ubuntu systems.

### Git Submodules

The repository uses git submodules for external dependencies:
- `vimrc`: Complete Vim configuration with plugins (from https://github.com/FerchoRiveraR/vimrc)

## Architecture

### Shell Configuration

**Bash** (`.bashrc`): Primary shell using bash-it framework
- Theme: minimal
- Standard Ubuntu bash configuration (history, colors, aliases)
- bash-it framework integration
- Version managers: NVM, rbenv, pyenv (initialized at shell startup)
- Terraform completion
- Git editor: vim

### Environment Setup

Version managers are used for runtime management:
- `NVM` for Node.js
- `rbenv` for Ruby
- `pyenv` for Python

PATH configurations prioritize:
1. `$HOME/.local/bin`
2. Version manager shims (pyenv, rbenv)
3. NVM managed Node.js
4. Machine-specific paths (e.g., Herd Lite)
5. System binaries

### Terminal Multiplexing

`.tmux.conf` configuration:
- Window numbering starts at 1
- Status bar centered with hostname, session, date/time
- Vim keybindings enabled
- Pane navigation shows current command
- Custom bindings: new windows/panes inherit current path

### Vim Configuration

The `vimrc/` submodule contains the complete Vim setup:
- **vimrc**: Main configuration file with settings and keybindings
- **pack/**: Native Vim 8+ package management, organized by category:
  - `coding/`: Language-specific plugins
  - `editor/`: Editor enhancement plugins
  - `lsp/`: Language Server Protocol integration
  - `theme/`: Color schemes (uses 'dim' colorscheme)
- **plugin/**: Custom plugin scripts
- **ftplugin/**: Filetype-specific configurations

Key vim settings:
- Leader key: `,` (comma)
- Relative line numbers enabled
- Undo files stored in `~/.vim/undodir` (no swap/backup files)
- Color column at 120 characters
- Buffer navigation: `<C-B>n` (next), `<C-B>p` (previous)
- File explorer shortcuts: `<Leader>e`, `<Leader>el`, `<Leader>er`, `<Leader>et`

## Common Commands

### Package Installation

```bash
# Install bash-it (if not already installed)
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh

# Install NVM (if not already installed)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Install rbenv (if not already installed)
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# Install pyenv (if not already installed)
curl https://pyenv.run | bash
```

### Dotfile Management

```bash
# Apply shell configuration changes
source ~/.bashrc

# Reload tmux configuration
# From within tmux, press prefix + r
```

### Submodule Management

```bash
# Clone repository with all submodules
git clone --recursive https://github.com/FerchoRiveraR/dotfiles.git

# Initialize submodules after cloning without --recursive
git submodule init
git submodule update

# Update all submodules to latest commits
git submodule update --remote

# Update specific submodule
git submodule update --remote vimrc
```

### Git Configuration

The `.gitconfig` sets:
- Default branch: `main`
- Git LFS filter enabled
- User: Your Name (YOUR_EMAIL@example.com)
- Editor: vim
- Merge tool: vimdiff
- Credential helper: GitHub CLI (`gh auth git-credential`)

#### Conditional Git Configuration for Work Directories

The repository supports different git configurations based on directory location using Git's `includeIf` feature:

- **Default (Personal)**: `YOUR_EMAIL@example.com` / `Your Name`
- **Work directories (`~/WORK_DIR/`)**: Uses `.gitconfig.work` with work email and name

The main `.gitconfig` includes:
```ini
[includeIf "gitdir:~/WORK_DIR/"]
    path = ~/.gitconfig.work
```

This automatically applies work credentials to all repositories under `~/WORK_DIR/`.

**How to verify:**
```bash
# Test personal email (in any repo outside ~/WORK_DIR/)
cd ~/fercho/dotfiles
git config user.email  # Should output: YOUR_EMAIL@example.com
git config user.name   # Should output: Your Name

# Test work email (in any repo inside ~/WORK_DIR/)
cd ~/WORK_DIR/some-work-repo
git config user.email  # Should output: WORK_EMAIL@example.com
git config user.name   # Should output: Your Name
```

### Git Commit Guidelines

When creating commit messages:
- **Do NOT include** "Co-Authored-By: Claude Code" or similar co-author attributions
- Use **Conventional Commits** format: `type(scope): description`
  - Types: `feat`, `fix`, `docs`, `chore`, `refactor`, `style`, `test`
  - Example: `feat(vim): add new plugin configuration`
  - Example: `chore(dotfiles): update shell aliases`

## Key Implementation Details

### Version Manager Initialization

The `.bashrc` initializes version managers in this order:
1. **bash-it**: Loads first for theme and shell enhancements
2. **NVM**: Node.js version management
3. **rbenv**: Ruby version management
4. **pyenv**: Python version management

### Terraform Integration

Terraform completion is enabled via:
```bash
complete -C /usr/bin/terraform terraform
```

This assumes Terraform is installed via APT or manual installation at `/usr/bin/terraform`.

### Tmux Pane Behavior

New tmux windows and panes inherit the current working directory:

```tmux
bind c new-window -c "#{pane_current_path}"
bind '"' split-window -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"
```

## Installation

### Quick Installation

Run the installation script to set up symlinks automatically:

```bash
cd ~/dotfiles  # or wherever you cloned the repo
./install.sh
```

The script will:
- Initialize git submodules (vimrc)
- Create symlinks for `.bashrc`, `.gitconfig`, `.gitconfig.work`, `.tmux.conf`
- Set up vim configuration symlinks (`~/.vim`, `~/.vimrc`)
- Report what was created or skipped

**Note**: The script is idempotent - you can run it multiple times safely. It will skip existing files and only create missing symlinks.

After running the script, follow the "Next Steps" guidance to:
1. Install dependencies (bash-it, NVM, rbenv, pyenv)
2. Reload your shell

### Manual Installation (Alternative)

If you prefer to install manually or want more control:

#### Fresh Ubuntu System Setup

1. Clone the repository:
   ```bash
   git clone --recursive https://github.com/FerchoRiveraR/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Backup existing dotfiles (if any):
   ```bash
   mv ~/.bashrc ~/.bashrc.backup
   mv ~/.gitconfig ~/.gitconfig.backup
   mv ~/.tmux.conf ~/.tmux.conf.backup
   ```

3. Create symbolic links:
   ```bash
   ln -s ~/dotfiles/.bashrc ~/.bashrc
   ln -s ~/dotfiles/.gitconfig ~/.gitconfig
   ln -s ~/dotfiles/.gitconfig.work ~/.gitconfig.work
   ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
   ln -s ~/dotfiles/vimrc ~/.vim
   ln -s ~/dotfiles/vimrc/vimrc ~/.vimrc
   ```

4. Install dependencies:
   ```bash
   # Install bash-it
   git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
   ~/.bash_it/install.sh

   # Install NVM
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

   # Install rbenv
   git clone https://github.com/rbenv/rbenv.git ~/.rbenv
   git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

   # Install pyenv
   curl https://pyenv.run | bash
   ```

5. Reload your shell:
   ```bash
   source ~/.bashrc
   ```
