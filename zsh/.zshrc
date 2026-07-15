# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Proxy toggle: proxy on / proxy off
proxy() {
  if [[ "$1" == "off" ]]; then
    unset http_proxy https_proxy all_proxy no_proxy NO_PROXY
    unset HOMEBREW_HTTP_PROXY HOMEBREW_HTTPS_PROXY HOMEBREW_ALL_PROXY HOMEBREW_NO_PROXY
    echo "Proxy disabled"
  else
    export http_proxy="http://127.0.0.1:7890"
    export https_proxy="http://127.0.0.1:7890"
    export all_proxy="http://127.0.0.1:7890"
    export no_proxy="localhost,127.0.0.1,token-plan-cn.xiaomimimo.com"
    export NO_PROXY="$no_proxy"
    export HOMEBREW_ALL_PROXY="http://127.0.0.1:7890"
    export HOMEBREW_NO_PROXY="localhost,127.0.0.1"
    echo "Proxy enabled (http://127.0.0.1:7890)"
  fi
}
proxy

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Hermes Agent — ensure ~/.local/bin is on PATH
export PATH="$HOME/.local/bin:$PATH"

# Draw Things CLI models directory
export DRAWTHINGS_MODELS_DIR="$HOME/Projects/draw-things-models"

# opencode
export PATH=/Users/hacxy/.opencode/bin:$PATH
alias oc=opencode

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/hacxy/.lmstudio/bin"
# End of LM Studio CLI section

# ===== 敏感信息请添加到 ~/.zshrc.local =====
# 例如:
#   export GITHUB_TOKEN="ghp_xxxx"
#   export HF_TOKEN="hf_xxxx"
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
