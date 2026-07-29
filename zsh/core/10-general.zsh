# ============================================================
# 通用配置
# ============================================================

# 编辑器
export VISUAL="nvim"
export EDITOR="nvim"

# 别名
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"

# Ghostty CLI
has ghostty && path_add "/Applications/Ghostty.app/Contents/MacOS"

# Hermes Agent
path_add "$HOME/.local/bin"
