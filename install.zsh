#!/bin/zsh
# Assumes there's git and zsh installed

DOTFILES="$HOME/.dotfiles"

# create dotfile directory if needed
if test ! -d "$DOTFILES"; then
  # clone repo
  git clone https://github.com/A-Gochnio/dotfiles.git "$DOTFILES"
fi

# go to repo
cd $DOTFILES

# update to newest version
git pull


# do the linking
cd "$DOTFILES"/link
for link_file in .[^.]*; do
  echo "Linking " $link_file " to " ~/$(basename $link_file)  
  ln -s "$link_file" ~/"$(basename $link_file)"
done

# do the sourcing

cd "$DOTFILES"/source
for source_file in *; do
  echo "Sourcing: " ~/$source_file
  source ~/"$source_file"
done

