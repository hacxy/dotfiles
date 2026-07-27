#!/bin/bash
# Git 安装脚本

tool_name() {
  echo "git"
}

tool_description() {
  echo "分布式版本控制系统"
}

check_installed() {
  command -v git &>/dev/null
}

install() {
  if check_installed; then
    echo "✓ Git 已安装"
    return 0
  fi
  
  # 检查依赖
  if ! command -v brew &>/dev/null; then
    echo "✗ 需要先安装 Homebrew"
    return 1
  fi
  
  echo "📦 安装 Git..."
  brew install git
  
  if check_installed; then
    echo "✓ Git 安装成功"
    return 0
  else
    echo "✗ Git 安装失败"
    return 1
  fi
}

configure() {
  # Git 不需要额外配置，使用系统默认配置
  return 0
}

status() {
  if check_installed; then
    local version=$(git --version)
    echo "installed|$version"
  else
    echo "not_installed|"
  fi
}