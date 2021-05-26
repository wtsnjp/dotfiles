#!/usr/bin/env sh
REPO_ROOT="$(pwd)"

ln -s "$REPO_ROOT/gitconfig" "$HOME/.gitconfig"
ln -s "$REPO_ROOT/gitignore.global" "$HOME/.gitignore.global"
ln -s "$REPO_ROOT/vimrc" "$HOME/.vimrc"
ln -s "$REPO_ROOT/zshrc" "$HOME/.zshrc"
