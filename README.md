# dotfiles

Personal development environment configuration.

## Quick Start

```bash
# Install all
bash -c "$(curl -fsSL https://raw.githubusercontent.com/hacxy/dotfiles/main/install.sh)"

# Install specific tools only
bash -c "$(curl -fsSL https://raw.githubusercontent.com/hacxy/dotfiles/main/install.sh)" -- --only=opencode,nvim

# Skip specific tools
bash -c "$(curl -fsSL https://raw.githubusercontent.com/hacxy/dotfiles/main/install.sh)" -- --skip=zsh

# Interactive selection
bash -c "$(curl -fsSL https://raw.githubusercontent.com/hacxy/dotfiles/main/install.sh)" -- --interactive
```

## What's Included

| Tool | Description |
|------|-------------|
| opencode | AI coding agent config + behavior rules (AGENTS.md) |
| nvim | Neovim config (lazy.nvim, LSP, 15+ plugins) |
| kitty | Terminal emulator (catppuccin-mocha + snazzy themes) |
| tmux | Terminal multiplexer (catppuccin theme, vim keybindings) |
| zsh | Shell config (oh-my-zsh, proxy toggle) |

## Install Options

```bash
./install.sh                        # Install all
./install.sh --only=opencode,nvim   # Install specific tools only
./install.sh --skip=kitty,zsh       # Skip specific tools
./install.sh --interactive          # Interactive selection
./install.sh --help                 # Show help
```

## Structure

```
dotfiles/
├── install.sh               # Remote-installable setup script
├── opencode/
│   ├── opencode.json        # Provider config (no secrets)
│   ├── opencode.jsonc       # Minimal template
│   ├── AGENTS.md            # Agent behavior rules
│   ├── package.json         # Plugin dependencies
│   └── skills/              # Custom skills
├── nvim/
│   ├── init.lua
│   ├── lua/config/          # Basic settings, keymaps, LSP
│   ├── lua/plugins/         # Plugin configs
│   └── after/               # Filetype & LSP overrides
├── kitty/
│   ├── kitty.conf
│   ├── current-theme.conf
│   └── themes/
├── tmux/
│   └── tmux.conf
└── zsh/
    ├── .zshrc
    └── .zshrc.local.example
```

## Post-Install Setup

```bash
# 1. Create sensitive info file
cp ~/dotfiles/zsh/.zshrc.local.example ~/.zshrc.local
vim ~/.zshrc.local  # Add your tokens

# 2. Setup OpenCode API key
oc  # Then run /connect to add API key

# 3. Restart terminal
source ~/.zshrc
```

## Security

- API keys are NOT stored in this repo
- OpenCode: use `/connect` command (stored in `~/.local/share/opencode/auth.json`)
- Zsh: sensitive env vars go in `~/.zshrc.local` (gitignored)

## How It Works

1. `install.sh` clones the repo to `~/dotfiles` (if not exists)
2. Creates symlinks from `~/.config/` to `~/dotfiles/`
3. Installs tmux plugin manager (tpm) and plugins
4. You manually setup secrets and API keys

## Updating

```bash
cd ~/dotfiles && git pull
# Symlinks auto-sync, no need to re-run install.sh
```
