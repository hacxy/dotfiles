# ============================================================
# Zsh 主配置入口
# ============================================================

# Oh My Zsh 配置
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# ============================================================
# 加载模块化配置（按编号顺序）
# ============================================================
local config_dir="${0:A:h}"  # 当前 .zshrc 所在目录

for f in "$config_dir"/core/*.zsh(N) "$config_dir"/tools/*.zsh(N); do
  source "$f"
done

# ============================================================
# 本地私有配置（不提交到 git）
# ============================================================
[[ -f "$config_dir/.zshrc.local" ]] && source "$config_dir/.zshrc.local" || true
