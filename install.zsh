#!/bin/zsh
# Assumes there's git and zsh installed

if [[ `uname` == 'Linux' ]]; then
  export OS=linux
elif [[ `uname` == 'Darwin' ]]; then
  export OS=osx
fi

export DOTFILES="$HOME/.dotfiles"
ZSH_CUSTOM="$HOME/.oh-my-zsh/"

# osx
if [[ $OS == 'osx' ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  INSTALL="brew update && brew"
  brew install gnu-sed
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

# install nvm (official installer) + Node 24 LTS as the default.
# PROFILE=/dev/null stops the installer appending init lines to .zshrc —
# .zshrc and .zprofile already source scripts/nvm_default_path.zsh.
export NVM_DIR="$HOME/.nvm"
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.5/install.sh | PROFILE=/dev/null bash
fi
source "$NVM_DIR/nvm.sh"
nvm install 24
nvm alias default 24

# do the linking
for link_file in "$DOTFILES"/link/.[^.]*; do
  home_file=~/"$(basename "$link_file")"
  echo "Linking $link_file to $home_file"
  if [ -f "$home_file" ] && [ -L "$home_file" ]; then
    echo "File $home_file exists and is a symlink. Unlinking..."
    rm "$home_file"
  elif [ -f "$home_file" ] && [ ! -L "$home_file" ]; then
    echo "File $home_file exists, renaming to ${home_file}.bak"
    mv "$home_file" "${home_file}.bak"
  fi
  ln -s "$link_file" ~/"$(basename "$link_file")"
done

# do the sourcing
source ~/.zshrc
