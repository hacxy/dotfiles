#!/bin/bash
# Pi coding agent 配置脚本

tool_name() {
  echo "pi"
}

tool_description() {
  echo "Pi coding agent 配置"
}

check_installed() {
  [ -L ~/.pi/agent ] || [ -d ~/.pi/agent ]
}

install() {
  # 检查 pi 是否已安装
  if ! command -v pi &>/dev/null; then
    echo "📦 安装 Pi coding agent..."
    
    # 检查 npm 是否可用
    if ! command -v npm &>/dev/null; then
      echo "✗ 需要先安装 Node.js 和 npm"
      return 1
    fi
    
    npm install -g @earendil-works/pi-coding-agent
    
    if ! command -v pi &>/dev/null; then
      echo "✗ Pi 安装失败"
      return 1
    fi
    
    echo "✓ Pi 安装完成"
  else
    echo "✓ Pi 已安装，跳过"
  fi
  
  return 0
}

configure() {
  local dotfiles_dir="$HOME/dotfiles"
  
  echo "📝 配置 Pi..."
  
  # 备份现有配置
  if [ -L ~/.pi/agent ]; then
    rm ~/.pi/agent
  elif [ -d ~/.pi/agent ]; then
    mv ~/.pi/agent ~/.pi/agent.bak
  fi
  
  # 创建符号链接
  mkdir -p ~/.pi
  ln -sf "$dotfiles_dir/pi" ~/.pi/agent
  
  if check_installed; then
    echo "✓ Pi 配置完成"
    return 0
  else
    echo "✗ Pi 配置失败"
    return 1
  fi
}

status() {
  if check_installed; then
    if [ -L ~/.pi/agent ]; then
      local target=$(readlink ~/.pi/agent)
      echo "installed|符号链接 -> $target"
    else
      echo "installed|目录"
    fi
  else
    echo "not_configured|"
  fi
}
