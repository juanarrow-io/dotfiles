#!/bin/zsh
# Run on a NEW profile (Work / Business), in a fresh Ghostty window.
#   zsh ~/.config/zsh/bootstrap-profile.sh
# Assumes Phase 4 (shared Homebrew on PATH) is already done.

set -euo pipefail
dot() { git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"; }

echo "── 1. oh-my-zsh"
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "   already installed"
else
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "── 2. dotfiles on top"
if [ -d "$HOME/.dotfiles" ]; then
  echo "   repo already present — pulling"
  dot pull --ff-only || true
else
  git clone --bare git@github.com:juanarrow-io/dotfiles.git "$HOME/.dotfiles"
fi
dot config status.showUntrackedFiles no
dot checkout -f     # deliberately overwrites the installer's default .zshrc

echo "── 3. custom plugins from the manifest"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
MANIFEST="$HOME/.config/zsh/omz-plugins.txt"
if [ ! -f "$MANIFEST" ]; then
  echo "   !! $MANIFEST missing — run prep-personal.sh on Personal and push first."; exit 1
fi
while read -r name url; do
  [ -n "${name:-}" ] || continue
  if [ -d "$ZSH_CUSTOM/plugins/$name" ]; then
    echo "   have $name"
  else
    git clone --depth=1 "$url" "$ZSH_CUSTOM/plugins/$name"
  fi
done < "$MANIFEST"

echo "── 4. dirs .zshrc expects"
mkdir -p "$HOME/.nvm" "$HOME/.go"

echo
echo "── Verify:"
echo "   echo \$ZSH ; ls \$ZSH/custom/plugins ; which oh-my-posh eza bat zoxide"
echo "   then:  exec zsh     # prompt should look identical to Personal"
