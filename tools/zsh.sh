#!/bin/bash
# Zsh 配置脚本

tool_name() {
  echo "zsh"
}

tool_description() {
  echo "Zsh shell 配置"
}

check_installed() {
  [ -L ~/.zshrc ] || [ -f ~/.zshrc ]
}

install() {
  # 检查 zsh 是否已安装
  if ! command -v zsh &>/dev/null; then
    if command -v brew &>/dev/null; then
      echo "📦 安装 Zsh..."
      brew install zsh
    else
      echo "✗ 需要先安装 Homebrew"
      return 1
    fi
  fi
  
  # 安装 oh-my-zsh
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📦 安装 oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
  
  # 安装 zsh-autosuggestions 插件
  local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  if [ ! -d "$zsh_custom/plugins/zsh-autosuggestions" ]; then
    echo "📦 安装 zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom/plugins/zsh-autosuggestions"
  fi
  
  echo "✓ Zsh 依赖安装完成"
  return 0
}

configure() {
  local dotfiles_dir="$HOME/dotfiles"
  
  echo "📝 配置 Zsh..."
  
  # 备份现有配置
  if [ -L ~/.zshrc ]; then
    rm ~/.zshrc
  elif [ -f ~/.zshrc ]; then
    mv ~/.zshrc ~/.zshrc.bak
  fi
  
  # 创建符号链接
  ln -sf "$dotfiles_dir/zsh/.zshrc" ~/.zshrc
  
  if check_installed; then
    echo "✓ Zsh 配置完成"
    echo "ℹ️  请重启终端或运行 'source ~/.zshrc' 来加载配置"
    return 0
  else
    echo "✗ Zsh 配置失败"
    return 1
  fi
}

status() {
  if check_installed; then
    if [ -L ~/.zshrc ]; then
      local target=$(readlink ~/.zshrc)
      echo "installed|符号链接 -> $target"
    else
      echo "installed|文件"
    fi
  else
    echo "not_configured|"
  fi
}