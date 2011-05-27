# ANSI color helpers
source $HOME/.bash/colors
# Set the PATH variable value
source $HOME/.bash/paths
# Various system-wide environemnt variables
source $HOME/.bash/config
# Ruby Enterprise Edition GC tuning
source $HOME/.bash/rubyee
# Aliases
source $HOME/.bash/aliases
# Helpful functions
source $HOME/.bash/functions
# Bash completions for various tools (rake, capistrano, etc)
source $HOME/.bash/completions
# Bash prompt tuning
source $HOME/.bash/prompt

# Machine specific settings
if [ -s "$HOME/.localrc" ]; then
  source $HOME/.localrc
fi
