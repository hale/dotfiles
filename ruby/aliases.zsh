alias migrate='rake db:migrate db:test:clone'
alias be='bundle exec'
alias rs='foreman run bundle exec rails s'
alias rc='foreman run bundle exec rails c'
alias dbm='bundle exec rake db:migrate'
alias dbtp='bundle exec rake db:test:prepare'
alias b='bundle'

# reset the database
dbreset() {
  set -e
  {
    be rake db:drop db:create db:schema:load db:test:prepare
  }
}

#prefix tests with rake, allows globbing.
tst() {
  be ruby -I test `bundle show rake`/lib/rake/rake_test_loader.rb test/(unit|functional|integration|acceptence|performance|capybara)/**/*$1*.rb
}

alias fr="foreman run"
alias fs='foreman start'
alias be='bundle exec'

# start running jobs on the named app
#
# Usage:
#
# heroku-jobs <app-name>
#
heroku-jobs() {
  heroku run rake jobs:work --app $1
}

# run rspec specs in bundler, foreman
alias fspec="foreman run bundle exec rspec"
alias fguard="foreman run bundle exec guard -c"

# rubinius
export RUBYOPT=rubygems

alias binstub-setup="ln -s `pwd`/.git/safe/binstubs `pwd`/bin"
