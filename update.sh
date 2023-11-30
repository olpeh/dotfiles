let -e # quit if anything fails

# cd to root of git repo
cd "$(dirname $0)"
CWD=$(pwd)

echo "Updating $HOME/dotfiles"
git pull
echo

cd $CWD
./symlink.sh -y
