HOME_CITY="Amsterdam"

# ======================
# ======= Main settings
# ======================

# System settings
export LANG=en_US.UTF-8

export EDITOR="nvim"
export PAGER="less"

setopt auto_cd

# Paths
export PNPM_HOME="$HOME/.local/share/pnpm"
typeset -U path PATH
path=(
  "$PNPM_HOME"
  "$HOME/.npm-global/bin"
  "$HOME/.local/bin"
  $path
)

# NPM
export NPM_CONFIG_PREFIX="$HOME/.npm-global"

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
alias s="sudo"
alias upd="sudo apt update && sudo apt dist-upgrade"
alias weather='curl "wttr.in/$HOME_CITY?lang=en"'
alias tm='tmux attach || tmux -2 new'
alias vi="nvim"
alias vim="nvim"
alias hm-pick="home-manager generations | fzf | awk -F '-> ' '{print $2 "/activate"}'"
alias o="xdg-open"

# ======================
# ======= History
# ======================

setopt sharehistory
setopt extendedhistory
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_save_no_dups
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
source "$ZSH_CONFIG_DIR/devshell.zsh"
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
