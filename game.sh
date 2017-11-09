#!/bin/sh

y_pos=""
while true; do
	clear
	echo "$y_pos Y"
	read -t 0.1 -n 1 c
	case "$c" in
		"l")
			y_pos="_$y_pos";;
		"h")
			y_pos=$(echo $y_pos | sed 's/_//');;
	esac
done

