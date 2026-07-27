#!/bin/bash
# Neovim 配置脚本

tool_name() {
  echo "nvim"
}

tool_description() {
  echo "Neovim 编辑器配置"
}

check_installed() {
  [ -L ~/.config/nvim ] || [ -d ~/.config/nvim ]
}

install() {
  # 检查依赖
  if ! command -v brew &>/dev/null; then
    echo "✗ 需要先安装 Homebrew"
    return 1
  fi
  
  echo "📦 安装 Neovim 依赖..."
  
  # 安装依赖包
  local packages=("git" "node" "tree-sitter-cli" "ripgrep" "fd" "lazygit" "luarocks" "imagemagick")
  
  for pkg in "${packages[@]}"; do
    if brew list "$pkg" &>/dev/null; then
      echo "✓ $pkg 已安装"
    else
      echo "📦 安装 $pkg..."
      brew install "$pkg"
    fi
  done
  
  echo "✓ Neovim 依赖安装完成"
  return 0
}

configure() {
  local dotfiles_dir="$HOME/dotfiles"
  
  echo "📝 配置 Neovim..."
  
  # 备份现有配置
  if [ -L ~/.config/nvim ]; then
    rm ~/.config/nvim
  elif [ -d ~/.config/nvim ]; then
    mv ~/.config/nvim ~/.config/nvim.bak
  fi
  
  # 创建符号链接
  ln -sf "$dotfiles_dir/nvim" ~/.config/nvim
  
  if check_installed; then
    echo "✓ Neovim 配置完成"
    echo "ℹ️  首次打开 Neovim 时，插件会自动安装"
    return 0
  else
    echo "✗ Neovim 配置失败"
    return 1
  fi
}

status() {
  if check_installed; then
    if [ -L ~/.config/nvim ]; then
      local target=$(readlink ~/.config/nvim)
      echo "installed|符号链接 -> $target"
    else
      echo "installed|目录"
    fi
  else
    echo "not_configured|"
  fi
}