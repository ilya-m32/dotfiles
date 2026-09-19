zmodload -i zsh/complist
autoload -Uz compinit

ZSH_CACHE_DIR=${XDG_CACHE_HOME:-$HOME/.cache}/zsh
mkdir -p "$ZSH_CACHE_DIR"
compinit -d "$ZSH_CACHE_DIR/zcompdump"

WORDCHARS=''
unsetopt menu_complete
setopt auto_menu
setopt complete_in_word
setopt always_to_end

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list \
  'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' \
  'r:|=*' \
  'l:|=* r:|=*'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

bindkey -M menuselect '^O' accept-and-infer-next-history
if [[ -n ${terminfo[kcbt]} ]]; then
  bindkey -M menuselect "${terminfo[kcbt]}" reverse-menu-complete
fi
