#!/bin/bash


set -euo pipefail

if ! [[ $# -eq 1 ]]; then
	echo "[!] ERROR! File not specified or more than one is provided."
	exit 1 
fi

if ! [[ -e "$1" ]]; then
	echo "File $1 does not exist."
        exit 1
fi

if ! [[ -s "$1" ]]; then
	echo "File $1 is empty"
	exit 1 
fi


url_regex='^(https?://)?(www\.)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(:[0-9]+)?(/.*)?$'


echo "CHECKING WEBSITES FROM A FILE..." 
echo "============"
while read -r lines; do
	for website in ${lines}; do
		if ! [[ "${website}" =~ ${url_regex} ]]; then
			echo " ${website} is not a valid URL. Skipping..."
			echo "============"
			continue
		fi
		echo "Checking status for ${website}"

		if ! curl -sSL --max-time 10 -o /dev/null -w "HTTP Response: %{http_code}\nResponse Time: %{time_total}s\n" "${website}"; then
			echo "[WARNING] Request failed for $website"
		fi
		echo "============"
	done
done <"$1"

echo "CHECK FINISHED FOR ALL WEBSITES IN A FILE"



