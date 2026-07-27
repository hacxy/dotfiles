#!/bin/bash
# OpenCode 配置脚本

tool_name() {
  echo "opencode"
}

tool_description() {
  echo "AI 编程助手配置"
}

check_installed() {
  [ -L ~/.config/opencode ] || [ -d ~/.config/opencode ]
}

install() {
  # OpenCode 不需要安装，只需要配置
  return 0
}

configure() {
  local dotfiles_dir="$HOME/dotfiles"
  
  echo "📝 配置 OpenCode..."
  mkdir -p ~/.config
  
  # 备份现有配置
  if [ -L ~/.config/opencode ]; then
    rm ~/.config/opencode
  elif [ -d ~/.config/opencode ]; then
    mv ~/.config/opencode ~/.config/opencode.bak
  fi
  
  # 创建符号链接
  ln -sf "$dotfiles_dir/opencode" ~/.config/opencode
  
  if check_installed; then
    echo "✓ OpenCode 配置完成"
    return 0
  else
    echo "✗ OpenCode 配置失败"
    return 1
  fi
}

status() {
  if check_installed; then
    if [ -L ~/.config/opencode ]; then
      local target=$(readlink ~/.config/opencode)
      echo "installed|符号链接 -> $target"
    else
      echo "installed|目录"
    fi
  else
    echo "not_configured|"
  fi
}