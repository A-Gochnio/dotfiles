# dotfiles

Configuration for command line tools. Sets up zsh (oh-my-zsh, agnoster_mod theme),
tmux, nano, nvm + Node 24, Homebrew packages, and symlinks everything in `link/`
into `$HOME`.

## Prerequisites

git and zsh (both ship with macOS). Everything else is installed by the script.

## Installation

```zsh
git clone https://github.com/A-Gochnio/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.zsh
```

The script is idempotent — safe to re-run. Existing real files in `$HOME` are
backed up to `<name>.bak` before being symlinked.

## Layout

- `link/` — files symlinked into `$HOME` (`.zshrc`, `.zprofile`, `.tmux.conf`, `.nanorc`, …)
- `source/` — sourced by `.zshrc` via `source.zsh`, in filename order.
  Files with `LOCAL` in the name are gitignored (per-machine aliases/secrets).
- `scripts/` — helper scripts (`nvm_default_path.zsh` is sourced by both
  `.zshrc` and `.zprofile` so the nvm default node is on PATH even in
  non-interactive login shells)
- `zsh-custom/` — oh-my-zsh custom dir (`agnoster_mod` theme)
- `conf/` — files copied (not symlinked) to system locations
- `Brewfile` — packages installed via `brew bundle`

## New-machine checklist (things this repo can NOT carry)

1. **LOCAL files** — copy from the old machine (gitignored, contain account
   IDs/secrets): `source/61_LOCAL_aliases`, `source/99_LOCAL_secrets`.
2. **SSH keys** — copy `~/.ssh/` keys, then store passphrases in the keychain:
   `ssh-add --apple-use-keychain ~/.ssh/<key>` (once per key; shells then
   auto-load them via `source/40_ssh-keys`).
3. **Git identity** — `~/.gitconfig` is not managed here. Set at minimum:
   `git config --global user.name / user.email`, plus commit-signing key if used.
   (`core.excludesFile` is wired by install.zsh.)
4. **Terminal font** — select a Powerline font in the terminal profile,
   otherwise the agnoster_mod prompt renders broken glyphs.
5. **tmux plugins** — inside tmux press `prefix + I` to make tpm install them.
6. **AWS** — copy `~/.aws/config`; re-add credentials via `aws-vault add <profile>`.
7. **Claude Code** — `~/.claude` (work) and `~/.claude-personal` are separate
   config dirs (see `claude-work` / `claude-personal` aliases).
8. **Review the Brewfile** — the commented-out section lists packages that were
   on the old machine; uncomment what the new one needs.
