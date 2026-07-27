#!/bin/bash
# dfm 设置脚本
# 用于将 dfm 命令添加到 PATH

set -e

DOTFILES_DIR="$HOME/dotfiles"
DFM_SCRIPT="$DOTFILES_DIR/dfm"
LINK_PATH="/usr/local/bin/dfm"

echo "=== dfm 设置脚本 ==="
echo ""

# 检查 dfm 脚本是否存在
if [ ! -f "$DFM_SCRIPT" ]; then
  echo "✗ 找不到 dfm 脚本: $DFM_SCRIPT"
  exit 1
fi

# 检查 dfm 脚本是否可执行
if [ ! -x "$DFM_SCRIPT" ]; then
  echo "📦 设置 dfm 脚本为可执行..."
  chmod +x "$DFM_SCRIPT"
fi

# 检查是否已经可以运行 dfm
if command -v dfm &>/dev/null; then
  echo "✓ dfm 命令已可用"
  dfm help
  exit 0
fi

echo "dfm 命令未在 PATH 中找到，请选择安装方式："
echo ""
echo "1. 创建符号链接到 /usr/local/bin/dfm (推荐)"
echo "2. 添加到 PATH（添加到 ~/.zshrc）"
echo "3. 跳过设置"
echo ""
read -p "请选择 [1/2/3]: " choice

case $choice in
  1)
    echo "📦 创建符号链接..."
    # 检查 /usr/local/bin/ 是否存在，不存在则创建
    if [ ! -d "/usr/local/bin" ]; then
      echo "📦 /usr/local/bin/ 目录不存在，正在创建..."
      sudo mkdir -p /usr/local/bin
    fi
    
    # 检查是否有写入权限
    if [ ! -w "/usr/local/bin" ]; then
      echo "需要管理员权限来创建符号链接"
      sudo ln -sf "$DFM_SCRIPT" "$LINK_PATH"
    else
      ln -sf "$DFM_SCRIPT" "$LINK_PATH"
    fi
    
    if [ -L "$LINK_PATH" ]; then
      echo "✓ 符号链接创建成功: $LINK_PATH -> $DFM_SCRIPT"
      echo "✓ dfm 命令现在可用"
      dfm help
    else
      echo "✗ 符号链接创建失败"
      exit 1
    fi
    ;;
  2)
    echo "📦 添加到 PATH..."
    # 检查是否已经在 .zshrc 中添加了 PATH
    if grep -q 'export PATH="$HOME/dotfiles:$PATH"' ~/.zshrc 2>/dev/null; then
      echo "✓ PATH 已经添加到 ~/.zshrc"
    else
      echo '' >> ~/.zshrc
      echo '# dotfiles PATH' >> ~/.zshrc
      echo 'export PATH="$HOME/dotfiles:$PATH"' >> ~/.zshrc
      echo "✓ 已添加到 ~/.zshrc"
    fi
    
    echo "ℹ️  请运行 'source ~/.zshrc' 或重启终端来使用 dfm 命令"
    ;;
  3)
    echo "跳过设置"
    echo "ℹ️  你可以手动运行: $DFM_SCRIPT"
    ;;
  *)
    echo "无效选择，跳过设置"
    ;;
esac