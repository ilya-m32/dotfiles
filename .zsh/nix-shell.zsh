function _nix_zsh_path() {
  if [[ -n "$SHELL" && -x "$SHELL" && "$SHELL" == *zsh* ]]; then
    print -r -- "$SHELL"
    return 0
  fi

  command -v zsh
}

function _nix_has_any_arg() {
  local arg

  for arg in "$@"; do
    case "$arg" in
      --command|--cmd|-c|--run|--help|-h)
        return 0
        ;;
    esac
  done

  return 1
}

function nix() {
  if [[ "$1" == "develop" && -t 0 && -t 1 ]] && ! _nix_has_any_arg "${@:2}"; then
    local zsh_path
    zsh_path="$(_nix_zsh_path)" || return 1
    command nix develop "${@:2}" --command "$zsh_path"
    return $?
  fi

  command nix "$@"
}

function nix-shell() {
  if [[ -t 0 && -t 1 ]] && ! _nix_has_any_arg "$@"; then
    local zsh_path
    zsh_path="$(_nix_zsh_path)" || return 1
    command nix-shell "$@" --run "exec ${(q)zsh_path}"
    return $?
  fi

  command nix-shell "$@"
}
