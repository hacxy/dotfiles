# dotfiles

> macOS Zsh 环境配置，模块化、可复现。

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-macos-lightgrey.svg)](https://www.apple.com/macos/)
[![Shell](https://img.shields.io/badge/shell-zsh-green.svg)](https://www.zsh.org/)

## 快速开始

```bash
curl -fsSL https://raw.githubusercontent.com/hacxy/dotfiles/main/install.sh | bash
```

一键完成：安装 Homebrew → Oh My Zsh → zsh-autosuggestions → 克隆仓库到 `~/dotfiles` → 创建 `.zshrc` 和 Starship 配置符号链接。

## 目录结构

```
zsh/
├── .zshrc                  # 入口文件 — 加载 Oh My Zsh 后按顺序加载模块
├── .zshrc.local.example    # 私有配置模板（GITHUB_TOKEN、HF_TOKEN 等）
├── core/
│   ├── 05-helpers.zsh      # 工具函数：OS 检测、has()、path_add()
│   └── 10-general.zsh      # 编辑器、别名、PATH 配置
└── tools/
    ├── 20-proxy.zsh        # proxy on/off/status — 管理代理环境变量
    └── 30-nvm.zsh          # NVM 延迟加载，首次调用 node/npm/npx 时才加载

starship/
└── starship.toml           # Starship 提示符配置 — 符号链接到 ~/.config/starship/
```

## 特性

- **模块化配置** — 在 `core/` 或 `tools/` 放一个 `.zsh` 文件即可自动加载，按文件名排序
- **NVM 延迟加载** — 首次执行 `node`、`npm` 或 `npx` 时才加载 NVM，加快 Shell 启动
- **代理切换** — `proxy on` / `proxy off` / `proxy status`，自动配置 Homebrew 代理变量
- **私有配置** — `.zshrc.local`（已 gitignore）存放 token 和机器专属配置
- **一键安装** — `install.sh` 自动处理 Homebrew、Oh My Zsh、插件、克隆、符号链接

## 安装

### 远程执行（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/hacxy/dotfiles/main/install.sh | bash
```

### 本地执行

```bash
git clone git@github.com:hacxy/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

## 使用

### 代理

```bash
proxy          # 开启代理（默认 127.0.0.1:7890）
proxy off      # 关闭代理
proxy status   # 查看代理状态
```

可通过环境变量覆盖默认地址：

```bash
export PROXY_HOST=192.168.1.100
export PROXY_PORT=1080
```

### 私有配置

```bash
cp zsh/.zshrc.local.example zsh/.zshrc.local
# 编辑 zsh/.zshrc.local，填入 GITHUB_TOKEN、HF_TOKEN 等
```

### 添加模块

在 `core/`（先加载）或 `tools/`（后加载）中创建 `.zsh` 文件，用数字前缀控制加载顺序：

```bash
# zsh/tools/50-aliases.zsh
alias ll="ls -la"
```

## 贡献

欢迎提交 Issue 或 Pull Request。

## 许可证

[MIT](LICENSE)
