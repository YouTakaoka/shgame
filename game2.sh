#!/bin/bash

CHARACTER="(^-^)"
MISSILE_SYMBOL="!"

function print_symbol () {
    line=""
    for i in `seq 1 $2`; do
        line=" $line"
    done
    line="${line}$1"
    echo "$line"
}

echo "This is tetris game."

while read -p "Start playing to press any key. To quit, press Ctrl+D." line; do
    x=10
    y=20
    is_missile_flying=0
    x_missile=0
    y_missile=0
    while [ 1 ]; do
        read -n 1 -t 0.1 c

        case "$c" in
            "q" )
                break;;
            "l" )
                x=$(($x + 1));;
            "h" )
                x=$(($x - 1));;
            "m" )
                if [ "$is_missile_flying" = "0" ]; then
                    is_missile_flying=1
                    x_missile=$x
                    y_missile=$y
                fi;;
        esac

        if [ "$is_missile_flying" = "1" ]; then
            y_missile=$(($y_missile - 1))
            if [ $y_missile -le 0 ]; then
                is_missile_flying=0
            fi
        fi

        clear

        #Draw characters
        for i in `seq 1 $y`; do
            if [ $i = $y ]; then
                print_symbol $CHARACTER $x
            elif [ $i = $y_missile ]; then
                print_symbol $MISSILE_SYMBOL $x_missile
            else
                echo ""
            fi
        done
    done
done
