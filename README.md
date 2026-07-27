# dotfiles

Personal development environment configuration.

## Quick Start

### 使用 dfm (推荐)

```bash
# 克隆仓库
git clone https://github.com/hacxy/dotfiles.git ~/dotfiles

# 添加 dfm 到 PATH（选择一种方式）
# 方式1: 创建符号链接
sudo ln -sf ~/dotfiles/dfm /usr/local/bin/dfm

# 方式2: 添加到 PATH（添加到 ~/.zshrc 或 ~/.bashrc）
export PATH="$HOME/dotfiles:$PATH"

# 交互式安装
dfm install

# 安装指定工具
dfm install brew nvim zsh

# 检查状态
dfm status

# 列出所有工具
dfm list
```

### 使用 install.sh (旧版)

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

### 基础工具

| Tool | Description |
|------|-------------|
| brew | macOS 包管理器 |
| git | 分布式版本控制系统 |
| nvm | Node.js 版本管理器 |

### 配置工具

| Tool | Description |
|------|-------------|
| opencode | AI coding agent config + behavior rules (AGENTS.md) |
| nvim | Neovim config (lazy.nvim, LSP, 15+ plugins) |
| kitty | Terminal emulator (catppuccin-mocha + snazzy themes) |
| ghostty | Ghostty terminal config |
| tmux | Terminal multiplexer (catppuccin theme, vim keybindings) |
| zsh | Shell config (oh-my-zsh, proxy toggle) |

## Install Options

### dfm 命令

```bash
dfm install              # 交互式安装
dfm install brew nvim    # 安装指定工具
dfm status               # 显示所有工具状态
dfm status nvim zsh      # 显示指定工具状态
dfm list                 # 列出所有可用工具
dfm help                 # 显示帮助
```

### install.sh (旧版)

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
├── dfm                    # 主命令行工具（可执行）
├── tools/                 # 工具脚本目录
│   ├── brew.sh
│   ├── git.sh
│   ├── nvm.sh
│   ├── opencode.sh
│   ├── nvim.sh
│   ├── kitty.sh
│   ├── ghostty.sh
│   ├── tmux.sh
│   └── zsh.sh
├── install.sh               # 旧版安装脚本（已弃用）
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
├── ghostty/
│   └── config
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

### dfm (推荐)

1. `dfm` 自动发现 `tools/` 目录下的工具脚本
2. 每个工具脚本实现统一的接口：`check_installed`、`install`、`configure`、`status`
3. `dfm` 自动处理工具依赖关系，按正确顺序安装
4. 安装状态存储在 `~/.dfm/` 目录，支持跳过已安装工具

### install.sh (旧版)

1. `install.sh` clones the repo to `~/dotfiles` (if not exists)
2. Creates symlinks from `~/.config/` to `~/dotfiles/`
3. Installs tmux plugin manager (tpm) and plugins
4. You manually setup secrets and API keys

## Updating

```bash
cd ~/dotfiles && git pull
# Symlinks auto-sync, no need to re-run install.sh
# dfm 会自动使用最新的工具脚本
```
