#!/bin/bash

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

VRISING_SERVER_DIR="$HOME/Steam/steamapps/common/VRisingDedicatedServer"

# Re-launch as 'gamemaster' if launched as root
if (( $EUID == 0 )); then
	runuser -u gamemaster -- bash "$SCRIPTPATH/manage.sh"
	exit $?
fi

if [ ! -d "$HOME/steamcmd" ]; then
	bash install_steamcmd.sh
fi

if [ ! -d "$VRISING_SERVER_DIR" ]; then
	bash install_vrising_server.sh
fi

if [ ! -d "$SCRIPTPATH/Servers" ]; then
	mkdir "$SCRIPTPATH/Servers"
fi

clear

while :; do
	echo "[V Rising Dedicated Server Manager]"
	echo "1) Run a server"
	echo "2) Create a new server"
	echo "3) Update V Rising"
	echo "0) Exit"
	echo ""

	echo -n "Choice: "

	read MENU_OPTION

	case $MENU_OPTION in
		1)
			pushd "$SCRIPTPATH/Servers"

			server_dirs=($(ls -d */))
			num_servers=${#server_dirs[@]}

			clear

			if (( $num_servers == 0 )); then
				>&2 echo "No servers found"
				sleep 1
			else
				echo "[Servers]"
				echo "0) Back"
				for (( i=0; i<${num_servers}; i++ ));
				do
					echo "$(($i+1))) ${server_dirs[$i]}"
				done
				echo ""

				echo -n "Choice: "

				read SERVER_CHOICE

				if (( ${SERVER_CHOICE} > ${num_servers} )); then
					>&2 echo "Invalid choice $SERVER_CHOICE"
					sleep 1
				elif (( $SERVER_CHOICE != 0 )); then
					server_dir=${server_dirs[$(($SERVER_CHOICE - 1))]}
					bash "$SCRIPTPATH/run_vrising_server.sh" "${server_dir%/}"
				fi
			fi

			popd

			clear

			;;

		2)
			clear

			echo "-- [Creating new V Rising Server]"

			while :; do
				echo -n "New folder name: "
				read VRISING_SERVER_FOLDER

				if [ -d "$VRISING_SERVER_FOLDER" ]; then
					>&2 echo "Folder already exists"
					echo
				else
					echo
					break
				fi
			done

			echo -n "Server name: "
			read VRISING_SERVER_NAME
			echo

			echo -n "Server description: "
			read VRISING_SERVER_DESC
			echo

			echo -n "Server password (leave blank for none): "
			read -s VRISING_SERVER_PASS
			echo

			mkdir -p "$SCRIPTPATH/Servers/$VRISING_SERVER_FOLDER"

			export VRISING_SERVER_NAME
			export VRISING_SERVER_DESC
			export VRISING_SERVER_PASS

			cp -a "$SCRIPTPATH/ServerTemplate/." "$SCRIPTPATH/Servers/$VRISING_SERVER_FOLDER"

			envsubst < "$SCRIPTPATH/ServerTemplate/Settings/ServerHostSettings.json" > "$SCRIPTPATH/Servers/$VRISING_SERVER_FOLDER/Settings/ServerHostSettings.json"

			echo "-- [Done]"
			sleep 1

			clear
			;;

		3)
			clear
			echo "-- [Installing V Rising Server]"
			bash install_vrising_server.sh
			echo "-- [Done]"
			sleep 1
			clear
			;;

		0)
			exit
			;;

		*)
			>&2 echo "Invalid choice $MENU_OPTION"
			sleep 1
			clear
			;;
	esac
done
