alias rc='docker compose run console bin/rails c'
alias dbm='docker compose run console bin/rails db:migrate'
alias dbtp='docker compose run specs rails db:test:prepare'
alias dbms='docker compose run specs rails db:migrate:status'
alias b='docker compose run console bundle'
alias be='docker compose run console bundle exec'

# reset the database
dbreset() {
  set -e
  {
    rake db:drop db:create db:schema:load db:test:prepare
  }
}

binstub-setup() {
  mkdir ./.git/safe
}
