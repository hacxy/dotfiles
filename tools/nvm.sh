#!/bin/bash
# nvm (Node Version Manager) 安装脚本

tool_name() {
  echo "nvm"
}

tool_description() {
  echo "Node.js 版本管理器"
}

check_installed() {
  [ -d "$HOME/.nvm" ] && [ -s "$HOME/.nvm/nvm.sh" ]
}

install() {
  if check_installed; then
    echo "✓ nvm 已安装"
    return 0
  fi
  
  echo "📦 安装 nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  
  # 加载 nvm
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  
  if check_installed; then
    echo "✓ nvm 安装成功"
    echo "ℹ️  请重启终端或运行 'source ~/.bashrc' 来使用 nvm"
    return 0
  else
    echo "✗ nvm 安装失败"
    return 1
  fi
}

configure() {
  # nvm 不需要额外配置，安装脚本会自动添加到 shell 配置
  return 0
}

status() {
  if check_installed; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    local version=$(nvm --version 2>/dev/null || echo "未知")
    echo "installed|v$version"
  else
    echo "not_installed|"
  fi
}