#!/bin/bash
# Ghostty 终端配置脚本

tool_name() {
  echo "ghostty"
}

tool_description() {
  echo "Ghostty 终端配置"
}

check_installed() {
  [ -L ~/.config/ghostty ]
}

install() {
  # Ghostty 不需要安装，只需要配置
  return 0
}

configure() {
  local dotfiles_dir="$HOME/dotfiles"
  
  echo "📝 配置 Ghostty..."
  
  # 备份现有配置
  if [ -L ~/.config/ghostty ]; then
    rm ~/.config/ghostty
  elif [ -d ~/.config/ghostty ]; then
    mv ~/.config/ghostty ~/.config/ghostty.bak
  fi
  
  # 创建符号链接（链接整个目录）
  ln -sf "$dotfiles_dir/ghostty" ~/.config/ghostty
  
  if check_installed; then
    echo "✓ Ghostty 配置完成"
    return 0
  else
    echo "✗ Ghostty 配置失败"
    return 1
  fi
}

status() {
  if check_installed; then
    if [ -L ~/.config/ghostty ]; then
      local target=$(readlink ~/.config/ghostty)
      echo "installed|符号链接 -> $target"
    else
      echo "installed|目录"
    fi
  else
    echo "not_configured|"
  fi
}