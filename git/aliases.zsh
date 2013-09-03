alias glg="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gp='git push'
alias gd='git diff'
alias gdc="git diff --cached"
alias gc='git commit --verbose'
alias gca='git commit --verbose -a'
alias gco='git checkout'
alias gb='git branch'
alias gs='git status' 
alias g='git status -sb'
alias gu="git-up" # gem install git-up
alias ga="git add"
alias gaa="git add --all"

# live git diff; requires kicker gem
gdl() {
  kicker -c -e "git diff --color" .
}

# shortcut to push to heroku staging
stage() {
  BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
  git push --force staging $BRANCH_NAME:master
}
