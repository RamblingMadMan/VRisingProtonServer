#!/bin/bash

set -e

# Make sure we don't install VRisingServer as root
if (( $EUID == 0 )); then
	>&2 echo "Do not install VRisingServer as root!"
	exit 1
fi

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

VRISING_FIX_DIR="$SCRIPTPATH/Fixes"
VRISING_SERVER_DIR="$SCRIPTPATH/Servers"

# Check for steamcmd
if [ ! -f "$HOME/steamcmd/steamcmd.sh" ]; then
	>&2 echo "Could not find steamcmd"
	exit 1
fi

pushd "$SCRIPTPATH"

if [ ! -d Servers ]; then
	mkdir Servers
fi

# Install windows version of server into "Servers" folder for running locally
# - VRisingServer (1829350)
$HOME/steamcmd/steamcmd.sh \
	+@sSteamCmdForcePlatformType windows \
	+force_install_dir "$VRISING_SERVER_DIR" \
	+login anonymous \
	+app_update 1829350 \
	+quit

popd

cp -r "$SCRIPTPATH/Steamworks/linux64" "$SCRIPTPATH/Steamworks/steamclient.so" "$VRISING_SERVER_DIR"
cp "$VRISING_FIX_DIR/stun_steamnetworking.dll" "$VRISING_SERVER_DIR/VRisingServer_Data/Plugins/x86_64"
