alias migrate='rake db:migrate db:test:clone'
alias be='bundle exec'

# reset the database
dbreset() {
  set -e
  {
    be rake db:drop
    be rake db:create
    be rake db:schema:load
    be rake db:test:prepare
    be rake db:seed
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
