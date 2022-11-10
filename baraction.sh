#!/bin/bash

## DISK
hdd() {
  hdd="$(df -h | awk 'NR==4{print $3, $5}')"
  echo -e " HDD: $hdd"
}

## RAM
mem() {
  mem=`free | awk '/Mem/ {printf "%dM/%dM\n", $3 / 1024.0, $2 / 1024.0 }'`
  echo -e " $mem"
}

## CPU
cpu() {
  read cpu a b c previdle rest < /proc/stat
  prevtotal=$((a+b+c+previdle))
  sleep 0.5
  read cpu a b c idle rest < /proc/stat
  total=$((a+b+c+idle))
  cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
  echo -e " CPU: $cpu%"
}

## VOLUME
vol() {
	vol=`amixer get Master | awk -F'[][]' 'END{ print $2 }' | sed 's/on://g'`
	echo -e " VOL: $vol"
}

## BATTERY
bat() {
   batt=$(cat /sys/class/power_supply/BAT0/capacity)
   batt_state=$(cat /sys/class/power_supply/BAT0/status | cut -c-1)
   echo -n " BAT: $batt_state$batt%"
}


SLEEP_SEC=3
#loops forever outputting a line every SLEEP_SEC secs

# It seems that we are limited to how many characters can be displayed via
# the baraction script output. And the the markup tags count in that limit.
# So I would love to add more functions to this script but it makes the 
# echo output too long to display correctly.
while :; do
	echo "$(cpu)   $(mem)   $(hdd)   $(vol)   $(bat)"
	sleep $SLEEP_SEC
done
