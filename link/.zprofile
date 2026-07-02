# Managed by ~/.dotfiles (symlinked by install.zsh).
# Sourced by zsh login shells — including NON-INTERACTIVE ones (`zsh -lc`,
# scripts, CI, editor tasks) which skip .zshrc. This guarantees the nvm
# default node resolves everywhere, not just in interactive terminals.
# Runs after /etc/zprofile (path_helper), so the nvm prepend stays first.
export DOTFILES="$HOME/.dotfiles"

source "$DOTFILES/scripts/nvm_default_path.zsh"

# python.org framework install, if present (pre-pyenv machines)
[ -d "/Library/Frameworks/Python.framework/Versions/3.12/bin" ] && export PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:$PATH"
