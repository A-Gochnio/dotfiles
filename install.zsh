#!/bin/zsh
# Assumes there's git and zsh installed
# Uncomment correct line for OS:
# OSX

if [[ `uname` == 'Linux' ]]; then
  export OS=linux
elif [[ `uname` == 'Darwin' ]]; then
  export OS=osx
fi

# osx
if [[ $OS == 'osx' ]]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  INSTALL="brew update && brew"
  brew install gnu-sed --with-default-names
  brew install nano
  brew install tmux
  cp "$DOTFILES"/conf/javascript.nanorc /usr/local/share/nano
  cp "$DOTFILES"/conf/.nanorc-osx ~/.nanorc
elif [[ $OS == 'linux' ]]; then
# ubuntu
  INSTALL="apt-get update && apt-get install"
  cp "$DOTFILES"/conf/javascript.nanorc /usr/share/nano
  cp "$DOTFILES"/conf/.nanorc-linux ~/.nanorc
fi


export DOTFILES="$HOME/.dotfiles"
ZSH_CUSTOM="$HOME/.oh-my-zsh/"

if test ! -d "$ZSH_CUSTOM"; then
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# create dotfile directory if needed
if test ! -d "$DOTFILES"; then
  git clone https://github.com/A-Gochnio/dotfiles.git "$DOTFILES"
fi

# go to repo
cd $DOTFILES

# update to newest version
git pull

# download necessary things:
# tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# fonts for terminal
git clone https://github.com/powerline/fonts.git ~/.powerline_fonts
source ~/.powerline_fonts/install.sh

# oh-my-zsh theme
echo 
cp -rf "$DOTFILES"/conf/agnoster.zsh-theme  "$ZSH_CUSTOM"/themes/

# do the linking
#cd "$DOTFILES"/link
for link_file in "$DOTFILES"/link/.[^.]*; do
  echo "Linking " $link_file " to " ~/$(basename $link_file)  
  ln -s "$link_file" ~/"$(basename $link_file)"
done

# do the sourcing
source ~/.zshrc

#cd "$DOTFILES"/source
#for source_file in *; do
#  echo "Sourcing: " $source_file
#  source "$source_file"
#done

