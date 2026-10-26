_tmux_project_name() {
  local root
  if root=$(git rev-parse --show-toplevel 2>/dev/null) && [[ -n $root ]]; then
    print -r -- ${root:t}
  elif [[ $PWD == $HOME ]]; then
    print -r -- '~'
  else
    print -r -- ${PWD:t}
  fi
}

_tmux_rename_window() {
  [[ -n $TMUX ]] || return
  local name
  name=$(_tmux_project_name) || return
  [[ -n $name ]] && tmux rename-window -t "$TMUX_PANE" "$name" 2>/dev/null
}

_tmux_pick_session() {
  local header=${1:-'tmux sessions'}
  local -a rows opts
  rows=("${(@f)$(tmux list-sessions -F $'#{session_name}\t#{session_windows}w\t#{?session_attached,attached,detached}\t#{session_id}' 2>/dev/null)}")
  rows=(${rows:#})
  (( ${#rows} )) || return 1

  opts=(
    --delimiter=$'\t'
    --with-nth=1,2,3
    --no-sort
    --header="$header"
    --preview='tmux list-windows -t {4} -F "#{window_index}: #{window_name}  #{pane_current_path}" 2>/dev/null'
    --preview-window=right,60%
  )

  if [[ -n $TMUX ]]; then
    print -rl -- "${rows[@]}" | fzf --tmux=center,80%,60% "${opts[@]}"
  else
    print -rl -- "${rows[@]}" | fzf --height=60% --reverse "${opts[@]}"
  fi
}

tm() {
  local sel id
  sel=$(_tmux_pick_session 'tmux sessions (enter: connect)')
  if [[ -z $sel ]]; then
    tmux list-sessions >/dev/null 2>&1 || print -r -- 'No tmux sessions. Create one with: tmn'
    return 1
  fi
  id=${sel##*$'\t'}
  if [[ -n $TMUX ]]; then
    tmux switch-client -t "$id"
  else
    tmux attach-session -t "$id"
  fi
}

tmn() {
  local name default id
  if (( $# )); then
    name=$1
  else
    default=$(_tmux_project_name)
    print -n "Session name [$default]: "
    read -r name
    [[ -z $name ]] && name=$default
  fi
  [[ -n $name ]] || return 1

  if tmux list-sessions -F '#{session_name}' 2>/dev/null | grep -qxF -- "$name"; then
    print -u2 "Session '$name' already exists; use tm to reconnect."
    return 1
  fi

  if [[ -n $TMUX ]]; then
    id=$(tmux new-session -d -s "$name" -c "$PWD" -P -F '#{session_id}') || return
    tmux switch-client -t "$id"
  else
    tmux new-session -s "$name" -c "$PWD"
  fi
}

tmk() {
  local sel name id reply
  sel=$(_tmux_pick_session 'tmux sessions (enter: kill)')
  if [[ -z $sel ]]; then
    tmux list-sessions >/dev/null 2>&1 || print -r -- 'No tmux sessions to kill.'
    return 1
  fi
  name=${sel%%$'\t'*}
  id=${sel##*$'\t'}
  print -n "Kill session '$name'? [y/N] "
  read -r reply
  [[ $reply == [yY]* ]] || return
  tmux kill-session -t "$id"
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd _tmux_rename_window
_tmux_rename_window
