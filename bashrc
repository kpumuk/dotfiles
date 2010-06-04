source ~/.bash/paths
HOMEBREW_PREFIX=`brew --prefix`

source ~/.bash/config
source ~/.bash/aliases
source ~/.bash/prompt
source ~/.bash/completions

if [ -f ~/.localrc ]; then
  . ~/.localrc
fi
