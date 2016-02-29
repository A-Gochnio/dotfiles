# Where the magic happens.
export DOTFILES=~/.dotfiles

# Add binaries into the path
PATH=$DOTFILES/bin:$PATH
export PATH

# Source all files in "source"
function src() {
  local file
  if [[ "$1" ]]; then
    emulate sh -c 'source "$DOTFILES/source/$1.sh"'
  else
    for file in $DOTFILES/source/*; do
      emulate sh -c 'source "$file"'
    done
  fi
}

# Run dotfiles script, then source.
function dotfiles() {
  $DOTFILES/bin/dotfiles "$@" && src
}

src
