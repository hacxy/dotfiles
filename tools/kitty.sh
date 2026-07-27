#!/bin/bash
# Kitty 终端配置脚本

tool_name() {
  echo "kitty"
}

tool_description() {
  echo "Kitty 终端配置"
}

check_installed() {
  [ -L ~/.config/kitty ] || [ -d ~/.config/kitty ]
}

install() {
  # 检查依赖
  if ! command -v brew &>/dev/null; then
    echo "✗ 需要先安装 Homebrew"
    return 1
  fi
  
  echo "📦 安装 Kitty 字体..."
  
  # 安装 JetBrainsMono Nerd Font Mono 字体
  FONT_NAME="JetBrainsMono Nerd Font Mono"
  if system_profiler SPFontsDataType 2>/dev/null | grep -q "$FONT_NAME"; then
    echo "✓ $FONT_NAME 字体已安装"
  else
    echo "📦 安装 $FONT_NAME 字体..."
    brew install --cask font-jetbrains-mono-nerd-font
  fi
  
  echo "✓ Kitty 依赖安装完成"
  return 0
}

configure() {
  local dotfiles_dir="$HOME/dotfiles"
  
  echo "📝 配置 Kitty..."
  
  # 备份现有配置
  if [ -L ~/.config/kitty ]; then
    rm ~/.config/kitty
  elif [ -d ~/.config/kitty ]; then
    mv ~/.config/kitty ~/.config/kitty.bak
  fi
  
  # 创建符号链接
  ln -sf "$dotfiles_dir/kitty" ~/.config/kitty
  
  if check_installed; then
    echo "✓ Kitty 配置完成"
    return 0
  else
    echo "✗ Kitty 配置失败"
    return 1
  fi
}

status() {
  if check_installed; then
    if [ -L ~/.config/kitty ]; then
      local target=$(readlink ~/.config/kitty)
      echo "installed|符号链接 -> $target"
    else
      echo "installed|目录"
    fi
  else
    echo "not_configured|"
  fi
}