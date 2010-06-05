# ANSI color helpers
source $HOME/.bash/colors
# Set the PATH variable value
source $HOME/.bash/paths
# Various system-wide environemnt variables
source $HOME/.bash/config
# Aliases
source $HOME/.bash/aliases
# Helpful functions
source $HOME/.bash/functions
# Bash completions for various tools (rake, capistrano, etc)
source $HOME/.bash/completions
# Bash prompt tuning
source $HOME/.bash/prompt

# Machine specific settings
[[ -s $HOME/.localrc ]] && source $HOME/.localrc
