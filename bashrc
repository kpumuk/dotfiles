source ~/.bash/paths
source ~/.bash/config
source ~/.bash/aliases
source ~/.bash/functions
source ~/.bash/completions
source ~/.bash/prompt

if [ -f ~/.localrc ]; then
  . ~/.localrc
fi
