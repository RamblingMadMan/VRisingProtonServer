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

STEAM_RUNTIME_DIR="$HOME/Steam/steamapps/common/SteamLinuxRuntime/steam-runtime"
PROTON_DIR="$HOME/Steam/steamapps/common/Proton - Experimental"
VRISING_SERVER_DIR="$SCRIPTPATH/Servers"

if [ ! -d "$SCRIPTPATH/.proton" ]; then
	mkdir "$SCRIPTPATH/.proton"
fi

pushd "$SCRIPTPATH/Servers"

#
# Run proton through steam runtime
#

export STEAM_COMPAT_DATA_PATH="$SCRIPTPATH/.proton"
export STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/Steam"
export PROTON_LOG=1
export PROTON_USE_WINED3D11=1
export WINE_DO_NOT_CREATE_DXGI_DEVICE_MANAGER=1

"$STEAM_RUNTIME_DIR/run.sh" xvfb-run "$PROTON_DIR/proton" run \
	"$VRISING_SERVER_DIR/VRisingServer.exe" -persistentDataPath "$1" -saveName "world1" -logFile "$1.log"

popd
