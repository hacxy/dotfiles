# Dotfiles 仓库指南

个人开发环境配置仓库，包含 opencode、nvim、kitty、tmux、zsh 五个工具的配置。

## 仓库结构

- `install.sh` — 安装脚本，创建 `~/.config/` 到 `~/dotfiles/` 的符号链接
- `opencode/` — OpenCode 配置 + `AGENTS.md`（全局行为规则，非仓库指南）
- `nvim/` — Neovim 配置（lazy.nvim 管理插件，`lazy-lock.json` 锁定版本）
- `kitty/` — Kitty 终端配置（catppuccin-mocha + snazzy 主题）
- `tmux/` — Tmux 配置（catppuccin 主题，vim 键位）
- `zsh/` — Zsh 配置（oh-my-zsh，proxy 切换函数）

## 关键约定

- **符号链接机制**：`install.sh` 将各目录软链到 `~/.config/`，修改 `~/dotfiles/` 下的文件即生效，无需重新运行安装脚本
- **敏感信息隔离**：API key 等放入 `~/.zshrc.local`（已 gitignore），不要提交到仓库
- **主要语言**：用户使用中文沟通，配置注释多为中文
- **Nvim 插件管理**：使用 lazy.nvim，`lazy-lock.json` 是插件版本锁文件，修改插件配置后需运行 `:Lazy sync`
- **Nvim 依赖**：通过 brew 安装，包括 `tree-sitter-cli`、`ripgrep`、`fd`、`lazygit`、`luarocks`、`imagemagick`
- **Zsh 代理**：`.zshrc` 中有 `proxy on/off` 切换函数，端口 `127.0.0.1:7890`
- **OpenCode 行为规则**：`opencode/AGENTS.md` 包含全局行为准则（确认优先、先理解再动手等），这是用户的核心偏好，不要覆盖或删除

## 操作提示

- 此仓库没有构建/测试/lint 流程，是纯配置文件
- 修改 nvim 配置后，用户需要重启 nvim 或执行 `:Lazy sync` 生效
- 修改 tmux 配置后，用户需要 `tmux source ~/.config/tmux/tmux.conf` 或重启 tmux
- 修改 zsh 配置后，用户需要 `source ~/.zshrc` 或重启终端
