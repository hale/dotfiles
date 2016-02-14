alias be='bundle exec'
alias rs='rails s --binding=0.0.0.0'
alias rc='rails c'
alias dbm='rake db:migrate'
alias dbtp='rake db:test:prepare'
alias dbms='rake db:migrate:status'
alias b='bundle'

# reset the database
dbreset() {
  set -e
  {
    rake db:drop db:create db:schema:load db:test:prepare
  }
}

#prefix tests with rake, allows globbing.
tst() {
  be ruby -I test `bundle show rake`/lib/rake/rake_test_loader.rb test/(unit|functional|integration|acceptence|performance|capybara)/**/*$1*.rb
}

alias be='bundle exec'

# start running jobs on the named app
#
# Usage:
#
# heroku-jobs <app-name>
#
#heroku-jobs() {
  #heroku run rake jobs:work --app $1
#}

# rubinius
export RUBYOPT=rubygems

binstub-setup() {
  mkdir ./.git/safe
}

alias isi="invoker start invoker.ini"
alias dj="RAILS_ENV=development bin/delayed_job"
