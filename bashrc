source ~/.bash/paths
HOMEBREW_PREFIX=`brew --prefix`

source ~/.bash/aliases
source ~/.bash/completions
source ~/.bash/config

if [ -f ~/.localrc ]; then
  . ~/.localrc
fi
