if [ -n "$IN_NIX_SHELL" ]; then
  devshell_name="${NIXPKG_SHELL_NAME:-$(basename "$PWD")}"
  PROMPT="${PROMPT}%F{yellow}[$devshell_name]%f "
  unset devshell_name
fi
