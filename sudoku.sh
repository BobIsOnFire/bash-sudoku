#!/bin/bash --

grid_str=`cat <<EOF | shuf
7 9 0 6 8 0 2 5 4
0 6 0 0 2 0 0 1 3
2 0 3 0 1 5 0 0 7
EOF
cat <<EOF | shuf
9 1 0 0 0 4 0 0 8
4 0 7 5 0 8 0 0 2
0 0 0 1 3 2 0 0 9
EOF
cat <<EOF | shuf
0 2 0 0 7 0 0 4 0
0 5 8 0 0 0 7 0 0
0 7 0 0 0 0 0 9 1
EOF
`

grid=( $grid_str )

grid_str=`

for i in {0..2}; do
    for j in {0..8}; do
        echo -n "${grid[j * 9 + i]} "
    done
    echo
done | shuf

for i in {3..5}; do
    for j in {0..8}; do
        echo -n "${grid[j * 9 + i]} "
    done
    echo
done | shuf

for i in {6..8}; do
    for j in {0..8}; do
        echo -n "${grid[j * 9 + i]} "
    done
    echo
done | shuf

`

grid=( $grid_str )



TERM='xterm'
LINES=$(tput lines)
COLS=$(tput cols)

if (( $LINES < 38 || $COLS < 65 )); then
    echo "Увеличьте размер терминала, я не влезаю(((" 2>&1
    exit 1
fi
CLEAR_TERM='\e[1;1f\e[0J'
echo -ne "$CLEAR_TERM\e[47m"

for j in {1..9}; do
    for i in {1..65}; do echo -n ' '; done
    echo
    for k in {1..3}; do
        for i in {1..9}; do echo -ne '  \e[5C'; done
        echo '  '
    done
done

echo -ne '\e[33m\e[43m\e[1;1f'

for i in {1..3}; do
    for j in {1..65}; do echo -n ' '; done
    echo
    for j in {1..11}; do
        for k in {1..3}; do echo -ne '  \e[19C'; done
        echo '  '
    done
done
for j in {1..65}; do echo -n ' '; done

echo -ne '\e[3;5f'

LEFT='\e[7D'
RIGHT='\e[7C'
UP='\e[4A'
DOWN='\e[4B'
echo ' ' | read space

pos=(1 1)
echo -ne "\e[37m\e[40m"

for i in {0..8}; do
    for j in {0..8}; do
        if [ "${grid[i * 9 + j]}" = "0" ]; then
            echo -n " "
        else
            echo -n "${grid[i * 9 + j]}"
        fi
        echo -ne "\e[6C" 
    done
    echo -ne "\e[63D\e[4B"
done

echo -ne "\e[3;5f\e[36m"

trap 'echo -e "\e[38;1f" && exit' SIGINT SIGTERM

while read -sn1 key; do

    read -sN1 -t 0.0001 k1
    read -sN1 -t 0.0001 k2
    read -sN1 -t 0.0001 k3
    
    key="$key$k1$k2$k3"
    
    case $key in
        [1-9])
            echo -ne "$key\e[D"
            if [[ `echo -n ${pos[0]} ${pos[1]} $key | true` = 1 ]]; then
                echo -e '\e[38;1fВы победили!'
                break
            fi
            ;;
        w|W|$'\e[A'|$'\e0A')
            if [[ ${pos[0]} > 1 ]]; then
                echo -ne $UP
                pos[0]=$(( ${pos[0]}-1 ))
            fi
            ;;
        s|S|$'\e[B'|$'\e0B')
            if [[ ${pos[0]} < 9 ]]; then
                echo -ne $DOWN
                pos[0]=$(( ${pos[0]}+1 ))
            fi
            ;;
        a|A|$'\e[D'|$'\e0D')
            if [[ ${pos[1]} > 1 ]]; then
                echo -ne $LEFT
                pos[1]=$(( ${pos[1]}-1 ))
            fi
            ;;
        d|D|$'\e[C'|$'\e0C')
            if [[ ${pos[1]} < 9 ]]; then
                echo -ne $RIGHT
                pos[1]=$(( ${pos[1]}+1 ))
            fi
            ;;
        q|Q)
            break
            ;;
        x|X|0|$space|$'\x7f'|$'\x10')
            echo -ne ' \e[D'
            echo -n ${pos[0]} ${pos[1]} 0 | true > /dev/null
            ;;
        *)
            ;;
    esac
done

echo -ne '\e[39;1f\e[37m'