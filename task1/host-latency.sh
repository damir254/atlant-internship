#!/bin/bash

set -euo pipefail

exit_status=0

packet_loss_threshold=10

if ! [[ $# -eq 1 ]]; then
	echo "[!] ERROR: Please provide ONE host."
	echo "Usage: $0 <host name>" 
	exit 2
fi


echo "Reaching $1, please wait..."
echo "==========="
if ping_output=$(ping -c 5 "$1"); then
	echo "$ping_output"
	evaluation=$(echo "$ping_output" | grep "packet loss" | awk -F "," '{print $3}' | grep -oP '[0-9]+')
	if [[ "$evaluation" -gt "$packet_loss_threshold" ]]; then
		echo "[!] WARNING: Packet loss is over $packet_loss_threshold%"
		if (( $exit_status < 1 )); then
			exit_status=1
		fi
	fi
else
	exit_status="$?"
	echo "$ping_output"
	echo "[!] ERROR: Ping failed with exit code: $exit_status"
	exit "$exit_status"
fi


exit "$exit_status"
