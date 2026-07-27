#!/bin/bash
# Tmux 配置脚本

tool_name() {
  echo "tmux"
}

tool_description() {
  echo "Tmux 终端复用器配置"
}

check_installed() {
  [ -L ~/.config/tmux/tmux.conf ] || [ -f ~/.config/tmux/tmux.conf ]
}

install() {
  # 检查 tmux 是否已安装
  if ! command -v tmux &>/dev/null; then
    if command -v brew &>/dev/null; then
      echo "📦 安装 Tmux..."
      brew install tmux
    else
      echo "✗ 需要先安装 Homebrew"
      return 1
    fi
  fi
  
  echo "✓ Tmux 已安装"
  return 0
}

configure() {
  local dotfiles_dir="$HOME/dotfiles"
  
  echo "📝 配置 Tmux..."
  mkdir -p ~/.config/tmux
  
  # 备份现有配置
  if [ -L ~/.config/tmux/tmux.conf ]; then
    rm ~/.config/tmux/tmux.conf
  elif [ -f ~/.config/tmux/tmux.conf ]; then
    mv ~/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf.bak
  fi
  
  # 创建符号链接
  ln -sf "$dotfiles_dir/tmux/tmux.conf" ~/.config/tmux/tmux.conf
  
  # 安装 tpm (Tmux Plugin Manager)
  local tpm_dir="$HOME/.config/tmux/plugins/tpm"
  if [ ! -d "$tpm_dir" ]; then
    echo "📦 安装 tpm..."
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
  fi
  
  # 安装 tmux 插件
  echo "📦 安装 tmux 插件..."
  "$tpm_dir/bin/install_plugins"
  
  if check_installed; then
    echo "✓ Tmux 配置完成"
    return 0
  else
    echo "✗ Tmux 配置失败"
    return 1
  fi
}

status() {
  if check_installed; then
    if [ -L ~/.config/tmux/tmux.conf ]; then
      local target=$(readlink ~/.config/tmux/tmux.conf)
      echo "installed|符号链接 -> $target"
    else
      echo "installed|文件"
    fi
  else
    echo "not_configured|"
  fi
}