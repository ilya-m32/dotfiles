alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gc='git commit'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch'
alias gp='git push'
alias gco='git checkout'
alias gsw='git switch'
alias gswc='git switch --create'
alias glog='git log --oneline --decorate --graph'
alias plog='git log --pretty=%s --graph'
alias gcnf='git diff --name-only --diff-filter=U'

function gcm() {
  for b in master main; do
    if git show-ref --quiet "refs/heads/$b"; then
      git switch "$b"
      return 0
    fi
  done

  echo "gcm: no master or main branch found" >&2
  return 1
}
