mkdir "$DOTFILES/tmp" && cd "$DOTFILES/tmp"
git clone https://github.com/nojhan/liquidprompt.git
cp "$DOTFILES/conf/liquidpromptrc" "~/.config/"
