# git log (pretty, only changes since master)
alias glg="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative  master..HEAD"

# git log long (pretty)
alias glgl="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"

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
alias gri="git rebase -i"
alias grem="git remote -v"
alias gra="git remote add"

# live git diff; requires kicker gem
gdl() {
  kicker -c -e "git diff --color" .
}

# shortcut to push to heroku staging
stage() {
  BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
  git push --force staging $BRANCH_NAME:master
}

# Remove a specific history from the history
#
# Usage:
#
# git-rm <commit SHA>
#
git-rm() {
  git rebase --onto $1^ $1
}
