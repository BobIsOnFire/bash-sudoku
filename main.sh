term_height=$(tput lines)
term_width=$(tput cols)

if [ $term_height -lt $field_height -o $term_width -lt $field_width ]; then
    echo "Terminal size should be at least $field_height x $field_width. Please resize." 2>&1
    exit 1
fi

# TODO: Save and load grids
grid=( $seed )
shuffle_grid
erase_tiles

draw_field

move $(( tile_height / 2 + 1 )) $(( tile_width / 2 + 1 ))
posx=0
posy=0

set_sudoku_nums_colors

trap 'reset_colors && status Aborted && exit' SIGINT SIGTERM

while true; do
    key=$(listen_key)
    case $key in
        [1-9])
            if [ -z "${editable[posy * 9 + posx]}" ]; then
                continue
            fi

            echo -n "$key"
            left 1

            grid[posy * 9 + posx]="$key"

            if check_finished; then
                reset_colors
                status You won!
                break
            fi
            ;;
        w|W|$key_up|$key_up_alt)
            if [ $posy -gt 0 ]; then
                up $(( tile_height + 1 ))
                posy=$(( posy - 1 ))
            fi
            ;;
        s|S|$key_down|$key_down_alt)
            if [ $posy -lt 8 ]; then
                down $(( tile_height + 1 ))
                posy=$(( posy + 1 ))
            fi
            ;;
        a|A|$key_left|$key_left_alt)
            if [ $posx -gt 0 ]; then
                left $(( tile_width + 1 ))
                posx=$(( posx - 1 ))
            fi
            ;;
        d|D|$key_right|$key_right_alt)
            if [ $posx -lt 8 ]; then
                right $(( tile_width + 1 ))
                posx=$(( posx + 1 ))
            fi
            ;;
        q|Q|$key_escape)
            reset_colors
            status Exit
            break
            ;;
        x|X|0|$key_space|$key_backspace)
            if [ -z "${editable[posy * 9 + posx]}" ]; then
                continue
            fi

            echo -n ' '
            left 1

            grid[posy * 9 + posx]=' '
            ;;
        *)
            ;;
    esac
done