alias zshrc="vim ~/.zshrc"
alias vimrc="vim ~/.vimrc"
function todo() {
  vim ~/Dropbox/todo_$(timestamp).markdown
}
alias q="exit"

# shortcut to the tree script. WARN: may conflict with todo.txt
alias t='tree'

alias ft02="ssh phale@192.168.1.95"

# oopsies
vom() { cat ~/.dotfiles/zsh/vom.txt }
guy() { cat ~/.dotfiles/zsh/guy.txt }
alias cim="vim"
alias :q="exit"

# use Back to My Mac to phone home over ipv6
imac() {
  ssh imac.$(echo show Setup:/Network/BackToMyMac | scutil | sed -n 's/.* : *\(.*\).$/\1/p')
}

