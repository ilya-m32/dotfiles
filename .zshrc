OS_TYPE=$(uname -s)
HOME_CITY="Amsterdam"

# ======================
# ======= Main settings
# ======================

# System settings
export LANG=en_US.UTF-8

export EDITOR="nvim"
export PAGER="less"
export TERM=tmux-256color
export KEYTIMEOUT=1

setopt auto_cd

# Paths
export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:$PATH"

# ssh
export SSH_KEY_PATH="~/.ssh/id_rsa"

# NPM
export NPM_CONFIG_PREFIX=~/.npm-global

# Load secret tokens
if [ -f ~/.tokens ]; then
  source ~/.tokens
fi

if [ -f ~/.profile ]; then
  source ~/.profile
fi

# Purely local profile (separate from ~/.profile)
if [ -f ~/.local_profile ]; then
  source ~/.local_profile
fi

# ======================
# ======= Alias
# ======================

alias sc="systemctl"
alias plog="git log --pretty=%s --graph"
alias s="sudo"
alias upd="sudo apt update && sudo apt dist-upgrade"
alias weather='curl "wttr.in/$HOME_CITY?lang=en"'
alias tm='tmux attach || tmux -2 new'
alias gcnf='git diff --name-only --diff-filter=U'
alias vi="nvim"
alias vim="nvim"
alias hm-pick="home-manager generations | fzf | awk -F '-> ' '{print $2 "/activate"}'"

if [ $OS_TYPE = "Linux" ]; then
  alias o="xdg-open"
elif [ $OS_TYPE = "Darwin" ]; then
  alias o="open"
fi

# ======================
# ======= History
# ======================

setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt extendedhistory
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_ignore_space
setopt hist_verify

HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=50000
SAVEHIST=10000
alias history='fc -lt "dd/mm/yyyy"'

# ======================
# ======= Zsh modules
# ======================

ZSH_CONFIG_DIR="${${(%):-%x}:A:h}/.zsh"
source "$ZSH_CONFIG_DIR/theme.zsh"
source "$ZSH_CONFIG_DIR/completion.zsh"
source "$ZSH_CONFIG_DIR/vi-mode.zsh"
source "$ZSH_CONFIG_DIR/git-aliases.zsh"
unset ZSH_CONFIG_DIR

# ======================
# ======= base16-themes
# ======================

if command -v tinty >/dev/null 2>&1; then
  tinty apply base16-tomorrow-night
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# pnpm
export PNPM_HOME="/home/ilya/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
