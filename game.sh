#!/bin/sh

# Field parameters
H=10
W=20

# Your machice
y_char="Y"
y_posx="__________" # x position of machine. Represented by the number of under-bars.
y_posy=10 # y position of machine. Represented by number.

# Missile
m_char="!"
m_posx=""
m_posy=0
m_flag=0 # Existion of missile. 0:None 1:Exists

# Object drawing function
function drw () {
	posx=$1 # x position of object
	char=$2 # Character symbol of object
	echo "$(echo "$posx" | sed 's/_/ /g')$char"
}

while true; do
	clear

	# Draw objects
	i=1
	while [ $i -le $H ]; do
		case "$i" in
		"$y_posy")
			# Drow your machine.
			drw $y_posx $y_char
			;;
		"$m_posy")
			# Drow missile.
			if [ $m_flag = 1 ]; then
				drw $m_posx $m_char
			fi
			;;
		*)
			# Draw nothing.
			echo ""
			;;
		esac
		i=$(( $i + 1 ))
	done

	# Calculate positions of objects
	if [ $m_posy -gt 0 ]; then
		m_posy=$(( $m_posy - 1 ))
	fi

	# Judge of touch
	if [ $m_posy = 0 ]; then
		m_flag=0
	fi

	# Catch keys
	read -t 0.0001 -n 1 c
	case "$c" in
		"l") # Hit l to move right
			y_posx="_$y_posx";;
		"h") # Hit h to move left
			y_posx=$(echo "$y_posx" | sed 's/_//');;
		"z") # Hit z to launch missile
			if [ "$m_flag" = "0" ]; then
				m_flag=1
				m_posx="$y_posx"
				m_posy=$(( $y_posy - 1 ))
			fi
	esac

	# Sleep a while
	sleep 0.001
done

