[[ -s "$HOME/.bashrc" ]] && source "$HOME/.bashrc"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$HOME/.localrc" ]] && source "$HOME/.localrc"

# NVM
export NVM_DIR="$HOME/.nvm"
[[ -s "$(brew --prefix nvm)/nvm.sh" ]] && source "$(brew --prefix nvm)/nvm.sh"

# added by Miniconda2 installer
export PATH="/Users/kpumuk/miniconda2/bin:$PATH"
