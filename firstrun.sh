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
    curl -L https://bit.ly/janus-bootstrap | bash//bit.ly/janus-bootstrap | bashddd "$(dirname $0)"

    ./update.sh
