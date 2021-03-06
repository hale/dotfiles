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
alias g='git status -sb'
alias gu="git up" # git config --global alias.up 'pull --rebase --autostash'
alias ga="git add"
alias gaa="git add --all"
alias gri="git rebase -i"
alias grem="git remote -v"
alias gra="git remote add"
alias gf="git find"
alias girc="git rebase --continue"
alias gira="git rebase --abort"
alias gsh="git show HEAD"
alias grh="git reset HEAD^"

# git merge last
alias gml="git merge --no-ff -"

alias remotes="git remote -v | column -t\t"

# live git diff; requires kicker gem
gdl() {
  kicker -c -e "git diff --color" .
}

# git reset --hard origin/<branch-name>
grho() {
  git reset --hard origin
  BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
  cmd="git reset --hard origin/$BRANCH_NAME"
  echo $cmd
  echo "Running in 3 seconds..."
  sleep 3
  eval $cmd
}

# shortcut to push to heroku staging
stage() {
  BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
  cmd="git push --force staging $BRANCH_NAME:master"
  echo $cmd
  echo "Running in 3 seconds..."
  sleep 3
  eval $cmd
}

# Remove a specific commit from the history
#
# Usage:
#
# git-rm <commit SHA>
#
git-rm() {
  git rebase --onto $1^ $1
}
