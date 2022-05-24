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

# Download AppIDs
# - Steam linux runtime "heavy" (1070560)
# - Proton Experimental (1493710)
pushd "$HOME"
./steamcmd/steamcmd.sh \
	+login anonymous \
	+app_update 1070560 \
	+app_update 1493710 \
	+quit
popd

# make directory for scout runtime in heavy
mkdir -p "$HOME/Steam/steamapp/common/SteamLinuxRuntime/steam-runtime"

# download and extract steam-runtime.tar.xz
pushd "$HOME/Steam/steamapp/common/SteamLinuxRuntime/steam-runtime"
curl -sqL "$STEAM_RUNTIME_URL" | tar zxvf -
popd
