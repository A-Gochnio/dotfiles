# nvm PATH setup, shared by .zshrc (interactive) and .zprofile (login shells).
# Puts the nvm default node on PATH without sourcing the slow nvm.sh.
export NVM_DIR="$HOME/.nvm"

# Put nvm default node on PATH dynamically (follows `nvm alias default <version>`)
_nvm_default=$(cat "$NVM_DIR/alias/default" 2>/dev/null)
_nvm_default=${_nvm_default#v}
if [[ -n "$_nvm_default" ]]; then
  _nvm_node_bin=$(ls -d "$NVM_DIR/versions/node/v${_nvm_default}"*/bin 2>/dev/null | sort -V | tail -1)
  [[ -n "$_nvm_node_bin" ]] && export PATH="$_nvm_node_bin:$PATH"
  unset _nvm_default _nvm_node_bin
fi

# Lazy nvm: sources nvm.sh on first `nvm` call (avoids slow nvm.sh at startup)
nvm() {
  unset -f nvm
  source "$NVM_DIR/nvm.sh"
  nvm "$@"
}
