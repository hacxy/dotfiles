#!/bin/bash
# dotfiles 安装脚本
# 用法:
#   全部安装: ./install.sh
#   指定工具: ./install.sh --only=opencode,nvim
#   排除工具: ./install.sh --skip=kitty,zsh
#   交互选择: ./install.sh --interactive
#   远程安装: bash -c "$(curl -fsSL https://raw.githubusercontent.com/hacxy/dotfiles/main/install.sh)"

set -e

DOTFILES_DIR="$HOME/dotfiles"
REPO_URL="https://github.com/hacxy/dotfiles.git"

# 默认安装所有
INSTALL_ALL=true
INSTALL_ONLY=""
SKIP=""
INTERACTIVE=false

# 解析参数
for arg in "$@"; do
  case $arg in
    --only=*)
      INSTALL_ALL=false
      INSTALL_ONLY="${arg#*=}"
      ;;
    --skip=*)
      SKIP="${arg#*=}"
      ;;
    --interactive|-i)
      INTERACTIVE=true
      INSTALL_ALL=false
      ;;
    --help|-h)
      echo "用法: ./install.sh [选项]"
      echo ""
      echo "选项:"
      echo "  --only=tool1,tool2    只安装指定工具"
      echo "  --skip=tool1,tool2    跳过指定工具"
      echo "  --interactive, -i     交互式选择"
      echo "  --help, -h            显示帮助"
      echo ""
      echo "可用工具: opencode, nvim, kitty, tmux, zsh"
      echo ""
      echo "示例:"
      echo "  ./install.sh                        # 安装全部"
      echo "  ./install.sh --only=opencode,nvim   # 只安装 opencode 和 nvim"
      echo "  ./install.sh --skip=zsh             # 跳过 zsh"
      echo "  ./install.sh --interactive          # 交互选择"
      exit 0
      ;;
  esac
done

# 如果 dotfiles 目录不存在，自动 clone
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "📦 克隆 dotfiles 仓库..."
  git clone "$REPO_URL" "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"

# 检查工具是否应该安装
should_install() {
  local tool=$1
  
  # 交互模式
  if [ "$INTERACTIVE" = true ]; then
    read -p "安装 $tool? [Y/n] " -n 1 -r
    echo
    [[ $REPLY =~ ^[Nn]$ ]] && return 1
    return 0
  fi
  
  # --only 模式
  if [ -n "$INSTALL_ONLY" ]; then
    echo ",$INSTALL_ONLY," | grep -q ",$tool," && return 0
    return 1
  fi
  
  # --skip 模式
  if [ -n "$SKIP" ]; then
    echo ",$SKIP," | grep -q ",$tool," && return 1
    return 0
  fi
  
  # 默认安装
  return 0
}

echo "🔧 开始安装 dotfiles..."

# --- OpenCode ---
if should_install "opencode"; then
  echo "📝 配置 OpenCode..."
  mkdir -p ~/.config
  [ -L ~/.config/opencode ] && rm ~/.config/opencode
  [ -d ~/.config/opencode ] && mv ~/.config/opencode ~/.config/opencode.bak
  ln -sf "$DOTFILES_DIR/opencode" ~/.config/opencode
fi

# --- Neovim ---
if should_install "nvim"; then
  echo "📝 配置 Neovim..."
  
  # 安装 nvim 依赖
  if command -v brew &>/dev/null; then
    install_brew_pkg() {
      local pkg="$1"
      local cmd="${2:-$1}"
      if ! command -v "$cmd" &>/dev/null; then
        echo "📦 安装 $pkg..."
        brew install "$pkg"
      fi
    }
    
    install_brew_pkg "git"
    install_brew_pkg "node"
    install_brew_pkg "tree-sitter-cli"
    install_brew_pkg "ripgrep" "rg"
    install_brew_pkg "fd"
    install_brew_pkg "lazygit"
    install_brew_pkg "luarocks"
    install_brew_pkg "imagemagick"
  else
    echo "⚠️  未安装 Homebrew，请手动安装以下依赖:"
    echo "   git, node, tree-sitter, ripgrep, fd, lazygit, luarocks, imagemagick"
    echo "   安装 Homebrew: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
  fi
  
  [ -L ~/.config/nvim ] && rm ~/.config/nvim
  [ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak
  ln -sf "$DOTFILES_DIR/nvim" ~/.config/nvim
fi

# --- Kitty ---
if should_install "kitty"; then
  echo "📝 配置 Kitty..."
  
  # 安装 JetBrainsMono Nerd Font Mono 字体
  FONT_NAME="JetBrainsMono Nerd Font Mono"
  if ! system_profiler SPFontsDataType 2>/dev/null | grep -q "$FONT_NAME"; then
    echo "📦 安装 $FONT_NAME..."
    if command -v brew &>/dev/null; then
      brew install --cask font-jetbrains-mono-nerd-font
    else
      echo "⚠️  未安装 Homebrew，请手动安装 $FONT_NAME 字体"
      echo "   下载地址: https://www.nerdfonts.com/font-downloads"
    fi
  fi
  
  [ -L ~/.config/kitty ] && rm ~/.config/kitty
  [ -d ~/.config/kitty ] && mv ~/.config/kitty ~/.config/kitty.bak
  ln -sf "$DOTFILES_DIR/kitty" ~/.config/kitty
fi

# --- Tmux ---
if should_install "tmux"; then
  echo "📝 配置 Tmux..."
  mkdir -p ~/.config/tmux
  [ -L ~/.config/tmux/tmux.conf ] && rm ~/.config/tmux/tmux.conf
  ln -sf "$DOTFILES_DIR/tmux/tmux.conf" ~/.config/tmux/tmux.conf

  # 安装 tpm (Tmux Plugin Manager)
  TPM_DIR="$HOME/.config/tmux/plugins/tpm"
  if [ ! -d "$TPM_DIR" ]; then
    echo "📦 安装 tpm..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  fi

  # 安装 tmux 插件
  echo "📦 安装 tmux 插件..."
  "$TPM_DIR/bin/install_plugins"
fi

# --- Zsh ---
if should_install "zsh"; then
  echo "📝 配置 Zsh..."
  
  # 安装 oh-my-zsh
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📦 安装 oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
  
  # 安装 zsh-autosuggestions 插件
  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "📦 安装 zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  fi
  
  [ -L ~/.zshrc ] && rm ~/.zshrc
  ln -sf "$DOTFILES_DIR/zsh/.zshrc" ~/.zshrc
fi

echo ""
echo "✅ dotfiles 安装完成！"
echo ""
echo "⚠️  接下来需要手动操作："
echo "   1. 创建敏感信息文件: cp $DOTFILES_DIR/zsh/.zshrc.local.example ~/.zshrc.local"
echo "   2. 编辑 ~/.zshrc.local 填入你的 token"
echo "   3. 在 OpenCode 中执行 /connect 命令添加 API Key"
echo "   4. 重启终端或执行 source ~/.zshrc"
