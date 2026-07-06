#!/bin/zsh
# Assumes there's git and zsh installed

if [[ `uname` == 'Linux' ]]; then
  export OS=linux
elif [[ `uname` == 'Darwin' ]]; then
  export OS=osx
fi

export DOTFILES="$HOME/.dotfiles"

# get the repo first — everything below uses files from it
if test ! -d "$DOTFILES"; then
  git clone https://github.com/A-Gochnio/dotfiles.git "$DOTFILES"
fi
cd "$DOTFILES"
git pull

# osx
if [[ $OS == 'osx' ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  # put brew on PATH for the rest of this script (Apple Silicon, then Intel fallback)
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null)" || eval "$(/usr/local/bin/brew shellenv)"
  brew bundle --file="$DOTFILES/Brewfile"
  # custom JS syntax next to brew-nano's syntax files (included by link/.nanorc)
  mkdir -p "$(brew --prefix)/share/nano"
  cp "$DOTFILES"/conf/javascript.nanorc "$(brew --prefix)/share/nano/"
elif [[ $OS == 'linux' ]]; then
# ubuntu
  cp "$DOTFILES"/conf/javascript.nanorc /usr/share/nano
fi

# oh-my-zsh (unattended: don't switch shell or replace .zshrc — linking handles it)
if test ! -d "$HOME/.oh-my-zsh"; then
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# tmux plugin manager (inside tmux, press prefix + I to install plugins)
[ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# fonts for terminal (agnoster_mod theme needs powerline glyphs —
# remember to select a Powerline font in the terminal profile afterwards)
if [ ! -d ~/.powerline_fonts ]; then
  git clone https://github.com/powerline/fonts.git ~/.powerline_fonts
  source ~/.powerline_fonts/install.sh
fi

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

# wire the global gitignore that the link loop just placed at ~/.gitignore_global
git config --global core.excludesFile ~/.gitignore_global

# do the sourcing
source ~/.zshrc
