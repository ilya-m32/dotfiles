OS_TYPE=$(uname -s)
HOME_CITY="Amsterdam"

# ======================
# ======= Main settings
# ======================

# System settings
export LANG=en_US.UTF-8

export EDITOR="vim"
export TERM=screen-256color
export KEYTIMEOUT=1

# zsh settings
ZSH_THEME="mh-vi"

CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"

ENABLE_CORRECTION="false"
COMPLETION_WAITING_DOTS="true"

DISABLE_UNTRACKED_FILES_DIRTY="false"

HIST_STAMPS="dd/mm/yyyy"

# Paths
export PATH=$HOME/.local/bin:$PATH
export PATH="$PATH:$HOME/.npm-global/bin"

# ssh
export SSH_KEY_PATH="~/.ssh/id_rsa"

# NPM
export NPM_CONFIG_PREFIX=~/.npm-global

# Load secret tokens
if [ -f ~/.tokens ]; then
  source ~/.tokens
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
alias gs='git status'
alias weather='curl "wttr.in/$HOME_CITY?lang=en"'
alias tm='tmux attach || tmux -2 new'
alias gcnf='git diff --name-only --diff-filter=U'
alias vi="nvim"
alias vim="nvim"
alias pip="pip3"

if [ $OS_TYPE = "Linux" ]; then
  alias o="xdg-open"
elif [ $OS_TYPE = "Darwin" ]; then
  alias o="open"
fi

# ======================
# ======= Oh-my-zsh!
# ======================

export ZSH=$HOME/.oh-my-zsh

plugins=(
  colorize
  docker
  fancy-ctrl-z
  git
  gnu-utils
  perl
  ripgrep
  rsync
  tmux
  vi-mode
  yarn
)

source $ZSH/oh-my-zsh.sh

# ======================
# ======= base16-themes
# ======================

BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
  [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
  eval "$("$BASE16_SHELL/profile_helper.sh")"

base16_tomorrow-night
