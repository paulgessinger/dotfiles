#!/bin/bash

mv ~/.bashrc ~/.bashrc.orig 2>/dev/null
mv ~/.vimrc ~/.vimrc.orig 2>/dev/null
mv ~/.gitconfig ~/.gitconfig.orig 2>/dev/null
mv ~/.tmux.conf ~/.tmux.conf.orig 2>/dev/null
mv ~/.zshrc ~/.zshrc.orig 2>/dev/null
mv ~/.bash_profile ~/.bash_profile.orig 2>/dev/null

ln -s ~/dotfiles/.bashrc.base ~/.bashrc
ln -s ~/dotfiles/.vimrc ~/.vimrc
mkdir -p ~/.vim
mkdir -p ~/.vim/backup
mkdir -p ~/.vim/swp
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.bash_profile ~/.bash_profile

wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

if [[ "$OSTYPE" == "darwin"* ]]; then
  mkdir -p ~/Library/Application\ Support
  ln -s ~/dotfiles/lazygit.yml ~/Library/Application\ Support/lazygit/config.yml
else
  mkdir -p ~/.config/lazygit
  ln -s ~/dotfiles/lazygit.yml ~/.config/lazygit/config.yml
fi
