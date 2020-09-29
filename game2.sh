#!/bin/bash

CHARACTER="(^-^)"
MISSILE_SYMBOL="!"
ENEMY_SYMBOL="X"
EMPTY="0"
ENEMY_ROWS=2
ENEMY_COLS=10
ENEMY_FALL_INTERVAL=20
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

echo "This is a game."

while read -p "Press any key to start. To quit, press Ctrl+D." line; do
    x=$INITIAL_X
    y=$INITIAL_Y
    is_missile_flying=false
    x_missile=0
    y_missile=0
    declare -a enemies=()
    y_enemy=1
    
    enemy_line=""
    for i in `seq 1 $ENEMY_COLS`; do
        enemy_line="$ENEMY_SYMBOL$enemy_line"
    done
    for i in `seq 1 $ENEMY_ROWS`; do
        enemies+=( $enemy_line )
    done
    cnt=0
    enemy_cnt=0
    gameover=false
    point=0
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

        # Move enemies
        if [ $enemy_cnt -ge $ENEMY_FALL_INTERVAL ]; then
            y_enemy=$(( $y_enemy + 1 ))
            enemy_cnt=0
        fi

        # Contact detection
        for i in `seq 0 $(( $ENEMY_ROWS - 1 ))`; do
            enemy_line=${enemies[$i]}
            j=$(( $y_enemy + $i ))

            # Missile vs enemies
            if [ $is_missile_flying = true -a $y_missile = $j -a "${enemy_line:$x_missile:1}" = "$ENEMY_SYMBOL" ]; then
                is_missile_flying=false
                enemy_line=`substitute $enemy_line $x_missile "$EMPTY"`
                enemies[$i]=$enemy_line
                point=$(( $point + 1 ))
            fi
            
            # Enemies vs player
            if [ $j = $y -a `echo $enemy_line | grep $ENEMY_SYMBOL` ]; then
                gameover=true
            fi
        done

        clear

        if $gameover; then
            echo "Game over. You got $point point."
            break
        fi

        if [ $point -ge $(( $ENEMY_ROWS * $ENEMY_COLS )) ]; then
            echo "Clear!"
            break
        fi

        #Draw characters
        for i in `seq 1 $y`; do
            if [ $i = $y ]; then
                print_symbol $CHARACTER $x
            elif [ $i -ge $y_enemy -a $i -lt $(( $y_enemy + $ENEMY_ROWS )) ]; then
                j=$(( $i - $y_enemy ))
                echo ${enemies[$j]} | sed -e 's/0/ /g'
            elif [ $is_missile_flying = true -a $i = $y_missile ]; then
                print_symbol $MISSILE_SYMBOL $x_missile
            else
                echo ""
            fi
        done
        echo $point
       
        sleep 0.1

        enemy_cnt=$(( $enemy_cnt + 1 ))
        
        # cnt=$(( $cnt + 1 ))
        # if [ $cnt -gt 10 ]; then
        #     break
        # fi
    done
done

