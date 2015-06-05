# create a new virtual environment in the current folder
alias vv2='virtualenv -p /usr/local/bin/python venv'
alias vv3='virtualenv -p /usr/local/bin/python3 venv'

# activate the virtual environment in the current directory
alias sv='source venv/bin/activate'

# upgrade pip
alias pup='pip install -U pip'

# `pip-compile requirements.in` -> requirements.txt
# requires the 'future' branch of pip-tools
#
# This is like the first part of 'bundle install' that generates a gemfile.
# Except it doesn't handle dependency management? Maybe it does.
alias pc='pip-compile requirements.in'

# Actually install dependencies.  Like the second half of bundle install
alias pir='pip install -r requirements.txt'
