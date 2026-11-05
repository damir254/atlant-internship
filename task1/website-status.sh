#!/bin/bash


set -euo pipefail

exit_code=0

if ! [[ $# -eq 1 ]]; then
	echo "[!] ERROR! File not specified or more than one is provided."
	exit 2 
fi

if ! [[ -e "$1" ]]; then
	echo "File $1 does not exist."
        exit 2
fi

if ! [[ -s "$1" ]]; then
	echo "File $1 is empty"
	exit 2 
fi


url_regex='^(https?://)?(www\.)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(:[0-9]+)?(/.*)?$'


echo "CHECKING WEBSITES FROM A FILE..." 
echo "============"
while read -r lines; do
	for website in ${lines}; do
		if ! [[ "${website}" =~ ${url_regex} ]]; then
			echo "[!] ERROR: ${website} is not a valid URL. Skipping..."
			echo "============"
			exit_code=2
			continue
		fi
		echo "Checking status for ${website}"

		if ! curl -fsSL --max-time 10 -o /dev/null -w "HTTP Response: %{http_code}\nResponse Time: %{time_total}s\n" "${website}"; then
			echo "[WARNING] Request failed for $website"
			if (( "$exit_code" < 1 )); then
				exit_code=1
			fi
		fi
		echo "============"
	done
done <"$1"

echo "CHECK FINISHED FOR ALL WEBSITES IN A FILE"


exit "$exit_code"


