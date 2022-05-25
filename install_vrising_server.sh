#!/bin/bash

set -e

# Make sure we don't install VRisingServer as root
if (( $EUID == 0 )); then
	>&2 echo "Do not install VRisingServer as root!"
	exit 1
fi

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

VRISING_FIX_DIR="$SCRIPTPATH/Fixes"
VRISING_SERVER_DIR="$HOME/VRisingProtonServer/Servers"

# Check for steamcmd
if [ ! -f "$HOME/steamcmd/steamcmd.sh" ]; then
	>&2 echo "Could not find steamcmd"
	exit 1
fi

pushd "$SCRIPTPATH"

if [ ! -d Servers ]; then
	mkdir Servers
fi

# Install server into "Servers" folder for running locally
# - VRisingServer (1829350)
$HOME/steamcmd/steamcmd.sh \
	+force_install_dir ./Servers \
	+login anonymous \
	+app_update 1829350 \
	+quit

popd

cp "$VRISING_FIX_DIR/stun_steamnetworking.dll" "$VRISING_SERVER_DIR/VRisingServer_Data/Plugins/x86_64"
