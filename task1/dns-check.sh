#!/bin/bash

set -euo pipefail

exit_status=0

if ! command -v dig > /dev/null; then
	echo "[!] ERROR: Command 'dig' not found. You must install it before using script."
	exit 2
fi

if [[ $# -lt 1 ]]; then
	echo "[!] ERROR: Script requires at least ONE argument"
	echo "Usage: $0 <example.com>"
	exit 2
fi

for host in "$@"; do 
	if ! resolved=$(dig "$host"); then
		echo "[!] ERROR: DNS Query failed for $host"
		exit_status=2
		continue
	fi
	echo "==========="
	echo "Resolving DNS for $host..."
	status=$(echo "$resolved" | grep -oP 'status: \K[a-zA-Z]+')
	query_time=$(echo "$resolved" | grep -oP 'Query time: \K[0-9]+\ [a-z]+')
	address=$(echo "$resolved" | awk '$4 == "A" {print $5}')
	echo "Resolution result: $status"
	if ! [[ $status == "NOERROR" ]]; then
		echo "[!] ERROR: FAILED DNS Resolution for $host"
		if (( $exit_status < 1 )); then
			exit_status=1
		fi
		continue
	else
		echo "Query time: $query_time"
		echo "Resolution address:"
		echo "$address"
	fi
	


done

exit "$exit_status"
