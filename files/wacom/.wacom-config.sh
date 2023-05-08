#!/bin/sh

for i in $(seq 10); do
	if xsetwacom list devices | grep -q Wacom; then
		break
	fi
	sleep 1
done

list=$(xsetwacom list devices)
stylus_id=$(echo "${list}" | sed -n '/type: STYLUS/ s/.*id: \([0-9]*\).*/\1/p')

xsetwacom set "${stylus_id}" Rotate half
