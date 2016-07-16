echo "WARNING!"
echo "--------"
echo "Don't run if you don't know what you are doing!"
echo
echo "are you sure you want to continue? (y/n)"
read answer
if [[ "$answer" != "y" ]]; then
	echo "aborting."
	exit
fi

# janus vim
function die()
{
    echo "${@}"
    exit 1
}

# Add .old to any existing Vim file in the directory
for filepath in ".vim" ".vimrc" ".gvimrc"; do
  if [ -e $filepath ]; then
    mv "${filepath}" "${filepath}.old" || die "Could not move ${filepath} to ${filepath}.old"
    echo "${filepath} has been renamed to ${filepath}.old"
  fi
done

# Clone Janus into .vim
git clone --recursive https://github.com/carlhuda/janus.git ".vim"

./update.sh
