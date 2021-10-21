term_height=$(tput lines)
term_width=$(tput cols)

if [ $term_height -lt $field_height -o $term_width -lt $field_width ]; then
    echo "Terminal size should be at least $field_height x $field_width. Please resize." 2>&1
    exit 1
fi

if [ -z "$load_file" ]; then
    grid=( $seed )
    shuffle_grid
    erase_tiles
    saved=
else
    load_grid "$load_file"
    if [ "$?" != "0" ]; then
        exit 1
    fi
    saved=1
fi

draw_field

tile_move 0 0
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
            saved=

            if check_finished; then
                reset_colors
                status You won!
                break
            fi
            ;;
        x|X|0|$key_space|$key_backspace)
            if [ -z "${editable[posy * 9 + posx]}" ]; then
                continue
            fi

            echo -n ' '
            left 1

            grid[posy * 9 + posx]=' '
            saved=
            ;;
        w|W|$key_up|$key_up_alt)
            if [ $posy -gt 0 ]; then
                posy=$(( posy - 1 ))
                tile_move $posy $posx
            fi
            ;;
        s|S|$key_down|$key_down_alt)
            if [ $posy -lt 8 ]; then
                posy=$(( posy + 1 ))
                tile_move $posy $posx
            fi
            ;;
        a|A|$key_left|$key_left_alt)
            if [ $posx -gt 0 ]; then
                posx=$(( posx - 1 ))
                tile_move $posy $posx
            fi
            ;;
        d|D|$key_right|$key_right_alt)
            if [ $posx -lt 8 ]; then
                posx=$(( posx + 1 ))
                tile_move $posy $posx
            fi
            ;;
        h|H)
            reset_colors
            status "$controls"
            set_sudoku_nums_colors
            tile_move $posy $posx
            ;;
        q|Q|$key_escape)
            reset_colors

            if [ -z "$saved" ]; then
                prompt_yn "Save game?"

                if [ "$prompt_answer" = "y" ]; then
                    prompt "Enter filename"
                    save_grid "$prompt_answer" 2>/tmp/sudoku-err.txt
                    if [ "$?" = "0" ]; then
                        status "Game saved to $(realpath $prompt_answer), exiting"
                        saved=1
                        break
                    else
                        status "Something went wrong while saving, try again"
                        cat /tmp/sudoku-err.txt
                        rm /tmp/sudoku-err.txt

                        set_sudoku_nums_colors
                        tile_move $posy $posx
                    fi
                else
                    status "Game not saved, exiting"
                    break
                fi
            else
                status "Exiting"
                break
            fi

            ;;
        g|G)
            reset_colors
            prompt "Enter filename"
            save_grid "$prompt_answer" 2>/tmp/sudoku-err.txt
            if [ "$?" = "0" ]; then
                status "Game saved to $(realpath $prompt_answer)"
                saved=1
            else
                status "Something went wrong while saving, try again"
                cat /tmp/sudoku-err.txt
                rm /tmp/sudoku-err.txt
            fi

            set_sudoku_nums_colors
            tile_move $posy $posx

            ;;
        $key_clear)
            reset_colors
            draw_field
            set_sudoku_nums_colors
            tile_move $posy $posx
            ;;
        *)
            ;;
    esac
done
