#!/usr/bin/env bash

# install.sh - Dotfiles installation script
# Usage: ./install.sh

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Counters for summary
CREATED=0
SKIPPED=0

# Function: create_symlink
# Args: source_file target_file
create_symlink() {
    local source="$1"
    local target="$2"

    if [ -L "$target" ]; then
        # Target is a symlink
        local current_source=$(readlink "$target")
        if [ "$current_source" = "$source" ]; then
            echo -e "${GREEN}✓${NC} $target already links to $source"
            return 0
        else
            echo -e "${YELLOW}⚠${NC} $target is a symlink to $current_source (skipping)"
            ((SKIPPED++))
            return 1
        fi
    elif [ -e "$target" ]; then
        # Target exists but is not a symlink
        echo -e "${YELLOW}⚠${NC} $target already exists (skipping)"
        ((SKIPPED++))
        return 1
    else
        # Target doesn't exist - create symlink
        ln -s "$source" "$target"
        echo -e "${GREEN}✓${NC} Created symlink: $target → $source"
        ((CREATED++))
        return 0
    fi
}

# Function: copy_if_not_exists
# Args: source_file target_file
copy_if_not_exists() {
    local source="$1"
    local target="$2"

    if [ -e "$target" ]; then
        echo -e "${GREEN}✓${NC} $target already exists (skipping copy)"
        return 0
    else
        cp "$source" "$target"
        echo -e "${GREEN}✓${NC} Copied $source → $target"
        ((CREATED++))
        return 0
    fi
}

# Main script

echo "=================================="
echo "Dotfiles Installation Script"
echo "=================================="
echo ""

# 1. Verify we're in the dotfiles directory
if [ ! -f ".gitmodules" ] || [ ! -f "CLAUDE.md" ]; then
    echo -e "${RED}Error: This script must be run from the dotfiles repository directory${NC}"
    echo "Please cd to your dotfiles directory and try again"
    exit 1
fi

DOTFILES_DIR="$(pwd)"
echo "Dotfiles directory: $DOTFILES_DIR"
echo ""

# 2. Initialize git submodules
echo "Initializing git submodules..."
git submodule init
git submodule update --recursive
echo ""

# 3. Create symlinks for main dotfiles
echo "Creating symlinks for dotfiles..."
create_symlink "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
create_symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
echo ""

# 3.5. Set up git configuration from templates
echo "Setting up git configuration..."
if [ ! -f "$HOME/.gitconfig" ]; then
    cp "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
    echo -e "${YELLOW}⚠${NC} Created ~/.gitconfig from template"
    echo -e "${YELLOW}  → Please edit with your personal information: vim ~/.gitconfig${NC}"
    ((CREATED++))
else
    echo -e "${GREEN}✓${NC} ~/.gitconfig already exists (skipping)"
fi

# Check if work directory exists (user should set WORK_DIR to their actual work directory)
WORK_DIR="$HOME/WORK_DIR"  # User should customize this path

if [ -d "$WORK_DIR" ] && [ ! -f "$HOME/.gitconfig.work" ]; then
    cp "$DOTFILES_DIR/.gitconfig.work.example" "$HOME/.gitconfig.work"
    echo -e "${YELLOW}⚠${NC} Created ~/.gitconfig.work from template"
    echo -e "${YELLOW}  → Please edit with your work information: vim ~/.gitconfig.work${NC}"
    echo -e "${YELLOW}  → Also update the includeIf path in ~/.gitconfig to match your work directory${NC}"
    ((CREATED++))
elif [ -f "$HOME/.gitconfig.work" ]; then
    echo -e "${GREEN}✓${NC} ~/.gitconfig.work already exists (skipping)"
elif [ ! -d "$WORK_DIR" ]; then
    echo -e "${GREEN}✓${NC} Work directory not found, skipping work git config"
    echo -e "  If you have work repos, edit install.sh to set WORK_DIR path"
fi
echo ""

# 4. Create vim symlinks
echo "Creating vim configuration symlinks..."
create_symlink "$DOTFILES_DIR/vimrc" "$HOME/.vim"
create_symlink "$DOTFILES_DIR/vimrc/vimrc" "$HOME/.vimrc"
echo ""


# 6. Summary
echo "=================================="
echo "Installation Summary"
echo "=================================="
echo -e "${GREEN}Created:${NC} $CREATED"
echo -e "${YELLOW}Skipped:${NC} $SKIPPED"
echo ""

# 7. Next steps
if [ $CREATED -gt 0 ]; then
    echo "=================================="
    echo "Next Steps"
    echo "=================================="
    echo ""
    echo "1. Personalize git configuration:"
    echo "   vim ~/.gitconfig  # Add your name, email, and update work directory path in includeIf"
    if [ -f "$HOME/.gitconfig.work" ] || [ -d "$WORK_DIR" ]; then
        echo "   vim ~/.gitconfig.work  # Add your work email"
    fi
    echo ""
    echo "2. Install system packages for tmux clipboard integration:"
    echo "   sudo apt install wl-clipboard xsel"
    echo ""
    echo "3. Install dependencies (if not already installed):"
    echo "   - bash-it: git clone https://github.com/Bash-it/bash-it.git ~/.bash_it && ~/.bash_it/install.sh"
    echo "   - NVM: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash"
    echo "   - rbenv: git clone https://github.com/rbenv/rbenv.git ~/.rbenv"
    echo "   - pyenv: curl https://pyenv.run | bash"
    echo ""
    echo "4. Reload your shell:"
    echo "   source ~/.bashrc"
    echo ""
    echo "For more details, see CLAUDE.md"
fi

if [ $SKIPPED -gt 0 ]; then
    echo ""
    echo "Note: $SKIPPED file(s) were skipped because they already exist."
    echo "Review the warnings above if you need to update them manually."
fi
