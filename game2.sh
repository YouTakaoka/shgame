#!/bin/bash

CHARACTER="(^-^)"
MISSILE_SYMBOL="!"
ENEMY_SYMBOL="X"
EMPTY="0"
ENEMY_ROWS=3
ENEMY_COLS=20
INITIAL_X=10
INITIAL_Y=20

# print_symbol <symbol> <position>
function print_symbol () {
    line=""
    for i in `seq 1 $2`; do
        line=" $line"
    done
    line="${line}$1"
    echo "$line"
}

# substitute <string> <position> <character>
function substitute () {
    s=$1
    x=$2
    c=$3
    s="${s:0:$x}$c${s:$(( $x + 1 ))}"
    echo $s
}

# srch <array> <element>
function srch () {
    j=1
    for i in $1; do
        if [ "$i" = "$2" ]; then
            echo $j
            return 0
        fi
        j=$(( $j + 1 ))
    done
    echo 0
}

echo "This is a game."

while read -p "Press any key to start. To quit, press Ctrl+D." line; do
    x=$INITIAL_X
    y=$INITIAL_Y
    is_missile_flying=false
    x_missile=0
    y_missile=0
    declare -a enemies=()
    declare -a y_enemies=(`seq 1 $ENEMY_ROWS`)
    
    enemy_line=""
    for i in `seq 1 $ENEMY_COLS`; do
        enemy_line="$ENEMY_SYMBOL$enemy_line"
    done
    for i in `seq 1 $ENEMY_ROWS`; do
        enemies+=( $enemy_line )
    done
    cnt=0
    while true; do
        # Catch key input
        read -n 1 -t 0.001 c

        case "$c" in
            "q" )
                break;;
            "l" )
                x=$(($x + 1));;
            "h" )
                x=$(($x - 1));;
            "m" )
                if [ $is_missile_flying = false ]; then
                    is_missile_flying=true
                    x_missile=$x
                    y_missile=$y
                fi;;
        esac

        # Move missile
        if $is_missile_flying; then
            y_missile=$(($y_missile - 1))
            if [ $y_missile -le 0 ]; then
                is_missile_flying=false
            fi
        fi

        # Contact detection
        for i in `seq 1 $ENEMY_ROWS`; do
            j=$(( $i - 1 ))
            mx=$x_missile
            #y_enemies[$j]=$(( ${y_enemies[$j]} + 1 ))
            enemy_line=${enemies[$j]}
            if [ $y_missile = ${y_enemies[$j]} -a "${enemy_line:$mx:1}" = "$ENEMY_SYMBOL" ]; then
                is_missile_flying=false
                enemy_line=`substitute $enemy_line $mx "$EMPTY"`
                enemies[$j]=$enemy_line
            fi
        done

        clear

        #Draw characters
        for i in `seq 1 $y`; do

            if [ $i = $y ]; then
                print_symbol $CHARACTER $x
            elif [ $i -ge ${y_enemies[0]} -a $i -le ${y_enemies[$(( $ENEMY_ROWS - 1 ))]} ]; then
                j=$(( $i - ${y_enemies[0]} ))
                echo ${enemies[$j]} | sed -e 's/0/ /g'
            elif [ $is_missile_flying = true -a $i = $y_missile ]; then
                print_symbol $MISSILE_SYMBOL $x_missile
            else
                echo ""
            fi
        done

        sleep 0.1
        
        # cnt=$(( $cnt + 1 ))
        # if [ $cnt -gt 10 ]; then
        #     break
        # fi
    done
done


















