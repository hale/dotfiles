# Load the anaconda environment (like a virtualenv)
# e.g. `sa accela_config`
alias sa='source activate'

# unload the virtualenv
alias sd='source deactivate'

# launch ipython notebook
alias ipyn='ipython notebook'

# list the available anaconda environments
alias cl='conda env list'

# create a list of packages installed in this env
alias clex='conda list --export > exported_packages.txt'

# ccf <env_name> to create a new conda environment using the list
ccf() {
  conda create -n $1 --file exported_packages.txt
}
