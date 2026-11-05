#!/bin/bash

set -euo pipefail

exit_code=0

Help()
{
	echo "Syntax: [-c|m|h]"
	echo "Example usage: ./system-usage.sh -m 80"
       	echo "Options:"	
	echo "c  Set CPU warning threshold. Default value is 80" 
	echo "m  Set Memory warning threshold. Default value is 80"
	echo "h  Print this help."
}




cpu_threshold=80
memory_threshold=80

while getopts ":hc:m:" option; do
	case $option in
		c) # Configure CPU Threshold
			if ! [[ "$OPTARG" =~ ^[0-9]+$ ]] || [[ "$OPTARG" -gt 100 ]]; then
				echo "[!] ERROR: Value must be integer between 0 and 100"
				exit 2
			fi
			cpu_threshold=$OPTARG;;
		m) # Configure Memory Threshold
			
			if ! [[ "$OPTARG" =~ ^[0-9]+$ ]] || [[ "$OPTARG" -gt 100 ]]; then
				echo "[!] ERROR: Value must be integer between 0 and 100"
				exit 2
			fi
			memory_threshold=$OPTARG;;
			
		h) # display Help
			Help
			exit 0;;
		\?)
			echo "Invalid option - -$OPTARG"
			Help
			exit 2;;
		:) 
			echo "Option -$OPTARG requires an argument."
			Help
			exit 2;;
	esac
done

read -r cpu us ni sys idle iowait irq softirq steal guest guest_nice < /proc/stat

total1=$(($us + $ni + $sys + $idle + $iowait + $irq + $softirq + $steal))
idle1=$((idle + iowait))

sleep 1

read -r cpu us ni sys idle iowait irq softirq steal guest guest_nice < /proc/stat

total2=$(($us + $ni + $sys + $idle + $iowait + $irq + $softirq + $steal))
idle2=$((idle + iowait))


delta_total=$((total2 - total1))
delta_idle=$((idle2 - idle1))

cpu_usage=$((100 * (delta_total - delta_idle) / delta_total))
echo "Current CPU Usage: $cpu_usage%"

memory_usage=$(free | grep "Mem" | awk '{print int((($2 - $7) / $2) * 100) }')
echo "Current Memory Usage: $memory_usage%"

if [[ $cpu_usage -gt $cpu_threshold ]]; then
	echo "[!] WARNING: CPU Usage is over $cpu_threshold%"
	exit_code=1
fi

if [[ $memory_usage -gt $memory_threshold ]]; then
	echo "[!] WARNING: Memory Usage is over $memory_threshold%"
	exit_code=1
fi


exit "$exit_code"

