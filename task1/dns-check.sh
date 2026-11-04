#!/bin/bash

set -euo pipefail


if ! command -v dig > /dev/null; then
	echo "[!] ERROR! Command 'dig' not found. You must install it before using script."
	exit 1
fi

if [[ $# -lt 1 ]]; then
	echo "[!] ERROR! Script requires at least ONE argument"
	echo "Usage: $0 <example.com>"
	exit 1
fi

for host in "$@"; do 
	if ! resolved=$(dig "$host"); then
		echo "DNS Query failed for $host"
		continue
	fi
	echo "==========="
	echo "Resolving DNS for $host..."
	status=$(echo "$resolved" | grep -oP 'status: \K[a-zA-Z]+')
	query_time=$(echo "$resolved" | grep -oP 'Query time: \K[0-9]+\ [a-z]+')
	address=$(echo "$resolved" | awk '$4 == "A" {print $5}')
	echo "Resolution result: $status"
	echo "Query time: $query_time"
	if [[ $status == "NXDOMAIN" ]]; then
		echo "Domain name $host does not exist."
		continue
	fi
	echo "Resolution address:"
	echo "$address"
	


done
