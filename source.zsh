#!/bin/zsh
# Source every regular file inside "$DOTFILES/source"

for source_file in "$DOTFILES"/source/*; do
  [[ -f $source_file ]] || continue   # skip sub-dirs, symlinks, etc.
  source "$source_file"
done
