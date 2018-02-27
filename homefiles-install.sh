#!/usr/bin/env bash

# Script for setting up a new environment with homefiles from repo.
# Based on articles https://news.ycombinator.com/item?id=11071754
# and
# https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/

function homefiles {
	/usr/bin/git --git-dir=$HOME/.homefiles/ --work-tree=$HOME $@
}

git clone --bare git@github.com:qlik-aoh/homefiles.git $HOME/.homefiles
homefiles checkout --quiet
if [ $? = 0 ]; then
	echo "Checked out homefiles.";
else
	echo "Backing up pre-existing dot files to .config-backup.";
	mkdir -p .config-backup
	homefiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;

homefiles checkout --quiet
homefiles config status.showUntrackedFiles no

