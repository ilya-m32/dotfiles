bindkey -v
KEYTIMEOUT=1
unsetopt flowcontrol

autoload -Uz \
  add-zle-hook-widget \
  edit-command-line \
  up-line-or-beginning-search \
  down-line-or-beginning-search

zle -N edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Edit the current command in $VISUAL or $EDITOR, then return it to the prompt.
bindkey -M vicmd 'V' edit-command-line
bindkey -M vicmd 'vv' edit-command-line

bindkey -M viins '^P' up-history
bindkey -M viins '^N' down-history
bindkey -M viins '^R' history-incremental-search-backward
bindkey -M viins '^S' history-incremental-search-forward
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^W' backward-kill-word

for keymap in viins vicmd; do
  bindkey -M "$keymap" '^[[A' up-line-or-beginning-search
  bindkey -M "$keymap" '^[[B' down-line-or-beginning-search

  [[ -n ${terminfo[kcuu1]} ]] && bindkey -M "$keymap" "${terminfo[kcuu1]}" up-line-or-beginning-search
  [[ -n ${terminfo[kcud1]} ]] && bindkey -M "$keymap" "${terminfo[kcud1]}" down-line-or-beginning-search
  [[ -n ${terminfo[khome]} ]] && bindkey -M "$keymap" "${terminfo[khome]}" beginning-of-line
  [[ -n ${terminfo[kend]} ]] && bindkey -M "$keymap" "${terminfo[kend]}" end-of-line
  [[ -n ${terminfo[kdch1]} ]] && bindkey -M "$keymap" "${terminfo[kdch1]}" delete-char
done
unset keymap

typeset -g VI_MODE_INDICATOR='%F{green}>>%B>%b%f'

function _vi_mode_keymap_select() {
  case $KEYMAP in
    vicmd|visual|viopp)
      VI_MODE_INDICATOR='%B%F{red}<%b<<%f'
      printf '\e[5 q'
      ;;
    *)
      VI_MODE_INDICATOR='%F{green}>>%B>%b%f'
      printf '\e[5 q'
      ;;
  esac
  zle reset-prompt
}

function _vi_mode_line_init() {
  VI_MODE_INDICATOR='%F{green}>>%B>%b%f'
  printf '\e[5 q'
}

function _vi_mode_line_finish() {
  printf '\e[5 q'
}

add-zle-hook-widget keymap-select _vi_mode_keymap_select
add-zle-hook-widget line-init _vi_mode_line_init
add-zle-hook-widget line-finish _vi_mode_line_finish
