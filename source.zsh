#!/bin/zsh
cd "$DOTFILES"/source
for source_file in *; do
  #echo "Sourcing: " $source_file
  source "$source_file"
done

cd ~
