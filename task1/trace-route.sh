#!/bin/bash


set -euo pipefail

Help()
{
echo "Usage: $0 <example.com>"
}


if ! command -v traceroute > /dev/null; then
	echo "[!] ERROR: Utility traceroute is needed in order to run this script."
	exit 2
fi

if ! [[ $# -eq 1 ]]; then
	echo "Script requires exactly ONE argument."
	Help
	exit 2
fi



echo "TRACING ROUTE FOR $1..."
if ! traceroute "$1"; then
	echo "[!] ERROR: Trace route failed for $1"
	Help
	exit 1
fi
