#!/bin/bash
# Homebrew 安装脚本

tool_name() {
  echo "brew"
}

tool_description() {
  echo "macOS 包管理器"
}

check_installed() {
  command -v brew &>/dev/null
}

install() {
  if check_installed; then
    echo "✓ Homebrew 已安装"
    return 0
  fi
  
  echo "📦 安装 Homebrew..."
  /bin/bash -c "$(curl -fsSL https://gitee.com/ineo6/homebrew-install/raw/master/install.sh)"
  
  # 添加 Homebrew 到 PATH（针对 Apple Silicon）
  if [[ $(uname -m) == "arm64" ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  
  if check_installed; then
    echo "✓ Homebrew 安装成功"
    return 0
  else
    echo "✗ Homebrew 安装失败"
    return 1
  fi
}

configure() {
  # Homebrew 不需要额外配置
  return 0
}

status() {
  if check_installed; then
    local version=$(brew --version | head -1)
    echo "installed|$version"
  else
    echo "not_installed|"
  fi
}