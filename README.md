# dotfiles

> macOS Zsh environment, modular and reproducible.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-macos-lightgrey.svg)](https://www.apple.com/macos/)
[![Shell](https://img.shields.io/badge/shell-zsh-green.svg)](https://www.zsh.org/)

## Quick Start

```bash
curl -fsSL https://raw.githubusercontent.com/hacxy/dotfiles/main/install.sh | bash
```

This installs Homebrew, Oh My Zsh, zsh-autosuggestions, clones the repo to `~/dotfiles`, and symlinks `.zshrc`.

## What's Inside

```
zsh/
├── .zshrc                  # Entry point — loads Oh My Zsh then sources modules
├── .zshrc.local.example    # Template for private tokens (GITHUB_TOKEN, HF_TOKEN, etc.)
├── core/
│   ├── 05-helpers.zsh      # Utility functions: OS detection, has(), path_add()
│   └── 10-general.zsh      # Editor, aliases, PATH entries
└── tools/
    ├── 20-proxy.zsh        # proxy on/off/status — manages HTTP proxy env vars
    └── 30-nvm.zsh          # Lazy-loads NVM on first node/npm/npx call
```

## Features

- **Modular config** — drop a `.zsh` file into `core/` or `tools/`, it loads automatically in filename order
- **Lazy NVM** — NVM is deferred until you actually run `node`, `npm`, or `npx`, keeping shell startup fast
- **Proxy toggle** — `proxy on` / `proxy off` / `proxy status` with Homebrew-aware env vars
- **Private config** — `.zshrc.local` (gitignored) for tokens and machine-specific settings
- **One-command setup** — `install.sh` handles Homebrew, Oh My Zsh, plugins, cloning, and symlinking

## Installation

### Remote (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/hacxy/dotfiles/main/install.sh | bash
```

### Local

```bash
git clone git@github.com:hacxy/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

## Usage

### Proxy

```bash
proxy          # enable proxy (default: 127.0.0.1:7890)
proxy off      # disable
proxy status   # check current state
```

Override defaults with environment variables:

```bash
export PROXY_HOST=192.168.1.100
export PROXY_PORT=1080
```

### Private Config

```bash
cp zsh/.zshrc.local.example zsh/.zshrc.local
# edit zsh/.zshrc.local — add GITHUB_TOKEN, HF_TOKEN, etc.
```

### Adding Modules

Create a `.zsh` file in `core/` (loaded first) or `tools/` (loaded second). Prefix with a number to control load order:

```bash
# zsh/tools/50-aliases.zsh
alias ll="ls -la"
```

## Contributing

Contributions welcome. Open an issue or submit a pull request.

## License

[MIT](LICENSE)
