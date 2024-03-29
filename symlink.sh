#!/bin/bash

# recursively symlink all files from paths in this array
FILES=( .tmux.conf .gitignore_global )

# symlink these directories
DIRS=( .tmux-resurrect )

# cd to root of git repo
cd "$(dirname $0)"
CWD=$(pwd)

# dry run mode enabled?
if [[ $1 == '-d' ]]; then
	DRYRUN=echo
else
	DRYRUN=
fi

if [[ $1 != '-y' ]]; then
	echo "WARNING! this script will backup the following files/dirs and put symlinks in their place:"
	echo files:
	echo ------
	find "${FILES[@]}" -printf "$HOME/%p\n"

	echo dirs:
	echo -----
	for DIR in $DIRS; do echo $HOME/$DIR; done

	echo -e "\nare you sure you want to continue? (y/n)"
	read answer
	if [[ "$answer" != "y" ]]; then
		echo "aborting."
		exit
	fi
fi

# symlink files
echo -e "\nsymlinking..."

find "${FILES[@]}" -print0 | while read -d $'\0' FILE; do

	# create parent directies if they do not exist
	if [ ! -d "$(dirname "$HOME/$FILE")" ]; then
		$DRYRUN mkdir -p $(dirname "$HOME/$FILE")
	fi

	# if file is a symlink, remove it and later make a new symlink
	if [ -L "$HOME/$FILE" ]; then
		$DRYRUN rm "$HOME/$FILE"
	# elif file already exists, make a backup
	elif [ -f "$HOME/$FILE" ]; then
		$DRYRUN mv -f "$HOME/$FILE" "$HOME/$FILE.bak"
		echo "backed up $HOME/$FILE => $HOME/$FILE.bak"
	fi

	echo "$HOME/dotfiles/$FILE => $HOME/$FILE"
	$DRYRUN ln -s "$HOME/dotfiles/$FILE" "$HOME/$FILE"
done

for DIR in $DIRS; do

	# create parent directies if they do not exist
	if [ ! -d "$(dirname "$HOME/$DIR")" ]; then
		$DRYRUN mkdir -p $(dirname "$HOME/$DIR")
	fi

	# if dir is a symlink, remove it and later make a new symlink
	if [ -L "$HOME/$DIR" ]; then
		$DRYRUN rm "$HOME/$DIR"
	# elif dir already exists, make a backup
	elif [ -d "$HOME/$DIR" ]; then
		$DRYRUN mv -f "$HOME/$DIR" "$HOME/$DIR.bak"
		echo "backed up $HOME/$DIR => $HOME/$DIR.bak"
	fi

	echo "$HOME/dotfiles/$DIR => $HOME/$DIR"
	$DRYRUN ln -s "$HOME/dotfiles/$DIR" "$HOME/$DIR"
done

echo
echo "all done!"
