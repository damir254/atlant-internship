#!/bin/bash

set -euo pipefail

if ! [[ $# -eq 1 ]]; then
	echo "[!] ERROR! Please provide ONE host."
	echo "Usage: $0 <host name>" 
	exit 1
fi


echo "Reaching $1, please wait..."
echo "==========="
if ! ping -c 5 "$1"; then
	echo "Failed to reach $1"
	exit 1 
fi

