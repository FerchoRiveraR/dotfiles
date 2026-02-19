# Fernando's dotfiles

Personal dotfiles for Linux systems (Arch + [omarchy](https://github.com/nicknisi/omarchy)), managed with [GNU Stow](https://www.gnu.org/software/stow/). Each directory is a stow package — install all of them or pick only what you need.

## Packages

| Package | Installs to | What it does |
|---------|-------------|--------------|
| `bash/` | `~/.config/bash/{rc,shell,envs,aliases}` | Shell options, personal env vars, and aliases — sourced as fragments on top of omarchy |
| `git/` | `~/.gitconfig` | Sets `init.defaultBranch = main` (credentials, LFS, identity configured separately) |
| `tmux/` | `~/.tmux.conf` | Vim-style keybindings, true color, mouse support, and Wayland/X11 clipboard auto-detection |

## Prerequisites

- **[omarchy](https://github.com/nicknisi/omarchy)** — provides starship (prompt), eza (ls), mise (runtimes), fzf, zoxide, history, completions, aliases, and sets `$EDITOR=nvim`
- **GNU Stow** — `sudo pacman -S stow`
- **Clipboard tools** (for tmux copy-mode) — `sudo pacman -S wl-clipboard xsel`

## Installation

```bash
# 1. Clone the repo
git clone https://github.com/FerchoRiveraR/dotfiles.git ~/dotfiles

# 2. Stow all packages (or pick only the ones you want)
cd ~/dotfiles
stow -t ~ bash git tmux

# 3. Add this line to ~/.bashrc (where omarchy says "Add your own")
source ~/.config/bash/rc

# 4. Reload
source ~/.bashrc
```

## Usage

### bash

The entry point is `~/.config/bash/rc`, which sources three fragments:

| File | Purpose |
|------|---------|
| `shell` | Shell options (`checkwinsize` — updates `LINES`/`COLUMNS` on terminal resize) |
| `envs` | Personal environment variables (empty by default — add your own) |
| `aliases` | Personal aliases (see below) |

**Aliases included:**

| Alias | Command |
|-------|---------|
| `grep` / `fgrep` / `egrep` | Adds `--color=auto` |
| `vi` / `vim` | Redirects to `nvim` |
| `c` | `claude --dangerously-skip-permissions` |
| `cc` | `claude --allow-dangerously-skip-permissions` |
| `oc` | `opencode` |

To add your own aliases or env vars, edit the corresponding file under `bash/.config/bash/` and re-stow or reload with `source ~/.bashrc`.

### tmux

The config sets vi mode, mouse support, true color, windows/panes starting at 1, and a minimal status bar. All keybindings use the default prefix (`Ctrl-b`).

**Pane navigation (vim-style):**

| Key | Action |
|-----|--------|
| `prefix + h` | Select pane left |
| `prefix + j` | Select pane down |
| `prefix + k` | Select pane up |
| `prefix + l` | Select pane right |

**Pane resize (repeatable):**

| Key | Action |
|-----|--------|
| `prefix + H` | Resize left 5 cells |
| `prefix + J` | Resize down 5 cells |
| `prefix + K` | Resize up 5 cells |
| `prefix + L` | Resize right 5 cells |

**Windows, sessions & utility:**

| Key | Action |
|-----|--------|
| `prefix + c` | New window (inherits current path) |
| `prefix + "` | Split horizontal (inherits current path) |
| `prefix + %` | Split vertical (inherits current path) |
| `prefix + S` | Prompt to create a new named session |
| `prefix + Space` | Jump to last window |
| `prefix + r` | Reload `~/.tmux.conf` |

**Copy mode (vi keys):**

Enter copy mode with `prefix + [`, then:

| Key | Action |
|-----|--------|
| `v` | Begin selection |
| `V` | Select line |
| `r` | Toggle rectangle selection |
| `y` | Copy selection to system clipboard and exit copy mode |

Clipboard is auto-detected: uses `wl-copy` on Wayland, `xsel` on X11.

### git

The `.gitconfig` is intentionally minimal — it only sets `init.defaultBranch = main`. Everything else is configured by their respective tools:

```bash
# Credentials (via GitHub CLI)
gh auth setup-git

# LFS
git lfs install

# Identity
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

# Editor uses $EDITOR (nvim, set by omarchy)
```

### Common commands

```bash
# Reload shell config
source ~/.bashrc

# Reload tmux config (from inside tmux)
# prefix + r

# Install runtimes (via mise, provided by omarchy)
mise install node@lts
mise install ruby@latest
mise install python@latest
```

## Development

### Adding a new stow package

Create a directory whose internal structure mirrors `$HOME`:

```bash
# Example: adding an alacritty package
mkdir -p alacritty/.config/alacritty
# Add your config file
vim alacritty/.config/alacritty/alacritty.toml

# Dry-run to verify what stow will do
stow -t ~ -nv alacritty

# Install
stow -t ~ alacritty
```

### Stow conventions

- Each top-level directory is one package
- The directory tree inside a package mirrors the target (`~`)
- Stow creates symlinks — the actual files stay in the repo
- Use `stow -t ~ -nv <package>` to preview before installing

### Commit format

This repo uses [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): description
```

Types: `feat`, `fix`, `docs`, `chore`, `refactor`, `style`, `test`

Example: `feat(tmux): add session management keybinding`

## Uninstall

```bash
cd ~/dotfiles

# 1. Remove symlinks
stow -t ~ -D bash git tmux

# 2. Remove the source line from ~/.bashrc
#    Delete: source ~/.config/bash/rc

# 3. Optionally delete the repo
rm -rf ~/dotfiles
```

## License

[MIT](LICENSE)
