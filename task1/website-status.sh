#!/bin/bash


set -euo pipefail

url_regex="^(https?:\/\/)?(www\.)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(:\d+)?(\/[^\s]*)?$"

echo "CHECKING WEBSITES..." 

while read -r lines; do
	for website in ${lines}; do
		echo "=============="
		if ! [[ "${website}" =~ ${url_regex} ]]; then
			echo " "${website}" is not a valid URL. Skipping..."
			continue
		fi
		echo "Checking status for "${website}""
		curl -sL -o /dev/null -w "HTTP Response: %{http_code}\nResponse Time: %{time_total}s\n" "${website}" 
	done
done <"$1"


