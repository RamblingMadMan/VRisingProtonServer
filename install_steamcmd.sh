#!/bin/bash

set -e

# Make sure we don't install steamcmd as root
if (( $EUID == 0 )); then
	>&2 echo "Do not install steamcmd as root!"
	exit 1
fi

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

STEAMCMD_URL="https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz"
STEAM_RUNTIME_URL="https://repo.steampowered.com/steamrt-images-scout/snapshots/0.20220315.0/steam-runtime.tar.xz"

function ensure_dir(){
	if [ ! -d "$1" ]; then
		mkdir -p "$1"
	fi
}

#
# Install steamcmd locally
#

if [ ! -d "$HOME/steamcmd" ]; then
	mkdir -p "$HOME/steamcmd"
fi

# download and extract steamcmd
pushd "$HOME/steamcmd"
curl -sqL "$STEAMCMD_URL" | tar zxvf -
popd

# Install Proton and the steamworks sdk
# - Proton Experimental (1493710)
pushd "$SCRIPTPATH"
$HOME/steamcmd/steamcmd.sh \
	+force_install_dir $SCRIPTPATH/Steamworks \
	+login anonymous \
	+app_update 1007 \
	+quit

$HOME/steamcmd/steamcmd.sh \
	+force_install_dir $SCRIPTPATH/Proton \
	+login anonymous \
	+app_update 1493710 \
	+quit
popd

# download and extract steam-runtime.tar.xz
pushd "$SCRIPTPATH"
curl -sqL "$STEAM_RUNTIME_URL" | tar xvfJ -
popd
