#!/bin/bash
# ============================================================
# Dotfiles 初始化脚本
# 用法:
#   远程执行: curl -fsSL https://raw.githubusercontent.com/hacxy/dotfiles/main/install.sh | bash
#   本地执行: ./install.sh
# ============================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
ok() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() {
	echo -e "${RED}[ERROR]${NC} $1"
	exit 1
}

# ============================================================
# 环境检测
# ============================================================

# 仅支持 macOS
if [[ "$(uname)" != "Darwin" ]]; then
	error "此脚本仅支持 macOS 系统"
fi

DOTFILES_REPO="https://github.com/hacxy/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

# ============================================================
# 安装 Homebrew
# ============================================================

install_homebrew() {
	if command -v brew &>/dev/null; then
		ok "Homebrew 已安装"
	else
		info "正在安装 Homebrew..."
		/bin/bash -c "$(curl -fsSL https://gitee.com/ineo6/homebrew-install/raw/master/install.sh)"

		# 添加 Homebrew 到 PATH（Apple Silicon）
		if [[ -f /opt/homebrew/bin/brew ]]; then
			eval "$(/opt/homebrew/bin/brew shellenv)"
		fi

		ok "Homebrew 安装完成"
	fi
}

# ============================================================
# 安装 Oh My Zsh
# ============================================================

install_oh_my_zsh() {
	if [[ -d "$HOME/.oh-my-zsh" ]]; then
		ok "Oh My Zsh 已安装"
	else
		info "正在安装 Oh My Zsh..."
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
		ok "Oh My Zsh 安装完成"
	fi
}

# ============================================================
# 安装 Zsh 插件
# ============================================================

install_zsh_plugins() {
	local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

	# zsh-autosuggestions
	if [[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
		ok "zsh-autosuggestions 已安装"
	else
		info "正在安装 zsh-autosuggestions..."
		git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
		ok "zsh-autosuggestions 安装完成"
	fi
}

# ============================================================
# 克隆 Dotfiles 仓库
# ============================================================

clone_dotfiles() {
	if [[ -d "$DOTFILES_DIR/.git" ]]; then
		ok "Dotfiles 仓库已存在，正在更新..."
		cd "$DOTFILES_DIR" && git pull
	else
		info "正在克隆 Dotfiles 仓库..."
		git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
		ok "Dotfiles 仓库克隆完成"
	fi
}

# ============================================================
# 创建符号链接
# ============================================================

create_symlinks() {
	info "正在创建符号链接..."

	# 备份已有的 .zshrc
	if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
		warn "备份已有的 .zshrc -> .zshrc.backup"
		mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
	fi

	# 移除已有的符号链接
	[[ -L "$HOME/.zshrc" ]] && rm "$HOME/.zshrc"

	# 创建符号链接
	ln -s "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
	ok ".zshrc -> $DOTFILES_DIR/zsh/.zshrc"

	# 创建 .zshrc.local（如果不存在）
	if [[ ! -f "$DOTFILES_DIR/zsh/.zshrc.local" ]]; then
		info "创建 .zshrc.local（请填入你的私有配置）"
		cp "$DOTFILES_DIR/zsh/.zshrc.local.example" "$DOTFILES_DIR/zsh/.zshrc.local"
		warn "请编辑 $DOTFILES_DIR/zsh/.zshrc.local 填入你的 token 等敏感配置"
	fi
}

# ============================================================
# 主流程
# ============================================================

main() {
	echo ""
	echo "============================================================"
	echo "  Dotfiles 初始化脚本"
	echo "============================================================"
	echo ""

	# 检测是否通过 curl | bash 执行
	if [[ -t 0 ]]; then
		read -p "是否继续安装？(y/N) " -n 1 -r
		echo
		[[ $REPLY =~ ^[Yy]$ ]] || exit 0
	fi

	install_homebrew
	install_oh_my_zsh
	clone_dotfiles
	install_zsh_plugins
	create_symlinks

	echo ""
	echo "============================================================"
	ok "安装完成！"
	echo "============================================================"
	echo ""
	info "下一步："
	echo "  1. 编辑私有配置: vim $DOTFILES_DIR/zsh/.zshrc.local"
	echo "  2. 重新加载配置: source ~/.zshrc"
	echo ""
}

main "$@"
