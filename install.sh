#!/usr/bin/env sh
REPO_ROOT="$(cd $(dirname $0); pwd)"

ln -s $REPO_ROOT/gitconfig $HOME/.gitconfig
ln -s $REPO_ROOT/gitignore.global $HOME/.gitignore.global
ln -s $REPO_ROOT/vimrc $HOME/.vimrc
ln -s $REPO_ROOT/zshrc $HOME/.zshrc

ZSH_FUNC_DIR="$HOME/.zsh/functions"
mkdir -p $ZSH_FUNC_DIR
ln -s $REPO_ROOT/zsh/functions/utility.zsh $ZSH_FUNC_DIR
