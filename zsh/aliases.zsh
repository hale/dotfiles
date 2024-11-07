if command -v nvim >/dev/null 2>&1; then
  alias vim='nvim'
  alias vi='nvim'
elif command -v mvim >/dev/null 2>&1; then
  alias vim='mvim -v'
  alias vi='mvim -v'
fi

alias q="exit"

# shortcut to the tree script. WARN: may conflict with todo.txt
alias t='tree'

alias ft02="ssh phale@192.168.1.95"

# oopsies
vom() { cat ~/.dotfiles/zsh/vom.txt }
guy() { cat ~/.dotfiles/zsh/guy.txt }
alias :q="exit"

# use Back to My Mac to phone home over ipv6
imac() {
  ssh imac.$(echo show Setup:/Network/BackToMyMac | scutil | sed -n 's/.* : *\(.*\).$/\1/p')
}

alias retag='ctags -R --languages=ruby --exclude=.git . $(bundle list --paths)'

alias clean-asl='sudo rm -rfv /private/var/log/asl/*.asl'
alias tf='terraform'
