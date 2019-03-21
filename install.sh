#!/bin/bash

# Run this from the dotfiles dir
DOTFILES=`pwd`

# bash
mv ~/.bashrc ~/.bashrc.local 2> /dev/null
ln -s $DOTFILES/bashrc ~/.bashrc
#touch ~/.bashrc.local

# vim
mv ~/.vimrc ~/.vimrc.old 2> /dev/null
mv ~/.vim ~/.vim.old 2> /dev/null
ln -s $DOTFILES/vimrc ~/.vimrc
ln -s $DOTFILES/vim ~/.vim

# tmux
mv ~/.tmux.conf ~/.tmux.conf.old 2> /dev/null
ln -s $DOTFILES/tmux.conf ~/.tmux.conf

# dircolors
mv ~/.dir_colors ~/.dir_colors.old 2> /dev/null
ln -s $DOTFILES/dircolors/dircolors.ansi-dark ~/.dir_colors

# sshconfig
rm -f ~/.ssh/config
ln -s $DOTFILES/sshconfig ~/.ssh/config

# gitconfig
rm -f ~/.gitconfig
ln -s $DOTFILES/gitconfig ~/.gitconfig

if [ -f /etc/redhat-release ]
then
    sudo yum -y install ctags-etags
fi

if [ -f /etc/debian_version ]
then
    sudo apt-get install exuberant-ctags vim --yes
fi

git submodule update --init

