#!/bin/bash

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

if (( $EUID == 0 )); then
	&>2 echo "Do not run game servers as root!"
	exit 1
fi

if (( $# != 1 )); then
	&>2 echo "Expected server folder name argument (Subfolder of 'Servers')"
	exit 1
fi

if [ ! -d "$SCRIPTPATH/Servers/$1" ]; then
	&>2 echo "Server folder \"$1\" does not exist"
	exit 1
fi

echo "Running server in folder \"$1\""

PROTON_DIR="$HOME/Steam/steamapps/common/Proton - Experimental"
VRISING_SERVER_DIR="$HOME/Steam/steamapps/common/VRisingDedicatedServer"

if [ ! -d "$SCRIPTPATH/.proton" ]; then
	mkdir "$SCRIPTPATH/.proton"
fi

pushd "$SCRIPTPATH/Servers"

export STEAM_RUNTIME=1
export STEAM_COMPAT_DATA_PATH="$VRISING_HOME_DIR/.proton"
export PROTON_LOG=1

xvfb-run "$PROTON_DIR/proton" run \
	"$VRISING_SERVER_DIR/VRisingServer.exe" -persistentDataPath "$1" -saveName "world1"

popd
