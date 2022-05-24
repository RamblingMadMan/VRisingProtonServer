#!/bin/bash

set -e

# Make sure we don't install VRisingServer as root
if (( $EUID == 0 )); then
	>&2 echo "Do not install VRisingServer as root!"
	exit 1
fi

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

VRISING_FIX_DIR="$SCRIPTPATH/Fixes"
VRISING_SERVER_DIR="$HOME/Steam/steamapps/common/VRisingDedicatedServer"

# Check for steamcmd
if [ ! -f "$HOME/steamcmd/steamcmd.sh" ]; then
	>&2 echo "Could not find steamcmd"
	exit 1
fi

pushd "$HOME"

# Install AppIDs
# - VRisingServer (1829350)
./steamcmd/steamcmd.sh \
	+login anonymous \
	+app_update 1829350 \
	+quit

popd

cp "$VRISING_FIX_DIR/stun_steamnetworking.dll" "$VRISING_SERVER_DIR/VRisingServer_Data/Plugins/x86_64"
