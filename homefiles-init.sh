#/usr/bin/env bash

# Script for inital setup of repo for managing files directly in $HOME,
# mainly meaning .config-files.
# Based on articles https://news.ycombinator.com/item?id=11071754
# and
# https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/

git init --bare $HOME/.homefiles
alias homefiles='/usr/bin/git --git-dir=$HOME/.homefiles/ --work-tree=$HOME'
alias hf='homefiles'
homefiles config --local status.showUntrackedFiles no
echo "alias homefiles='/usr/bin/git --git-dir=$HOME/.homefiles/ --work-tree=$HOME'" >> $HOME/.bashrc
echo "alias hf='homefiles'" >> $HOME/.bashrc
hf add $HOME/.bashrc
hf commit -m "Add .bashrc for initial commit"

# If cloning, make sure to replace this with your own URL
hf remote add origin git@github.com:qlik-aoh/homefiles.git
hf push origin -u master

