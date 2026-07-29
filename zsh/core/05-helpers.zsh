# ============================================================
# 工具函数
# ============================================================

# OS 检测
[[ "$OSTYPE" =~ ^darwin ]] && __IS_MACOS=1 || __IS_MACOS=0
[[ "$OSTYPE" =~ ^linux ]] && __IS_LINUX=1 || __IS_LINUX=0
is_macos() { (( __IS_MACOS )); }
is_linux() { (( __IS_LINUX )); }

# 命令存在性检测
# shellcheck disable=SC2154
has() { (( $+commands[$1] )); }

# PATH 管理（防止重复添加）
path_add() {
  [[ -d "$1" ]] && (( ${path[(Ie)$1]} == 0 )) && path+=("$1")
}
