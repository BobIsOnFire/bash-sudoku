##### Field drawing engine.

tile_height=1
tile_width=3

# Deduced from above, overall field size is the sum of 9 tiles and 10 borders.
field_height=$(( 9 * $tile_height + 10 ))
field_width=$(( 9 * $tile_width + 10 ))

function repeat() {
    str="$1"; shift
    reps="$1"; shift

    for i in $(seq 1 $reps); do
        echo "$str"
    done
}

function draw_border_template() {
    template="$1"; shift
    tileborder="$1"; shift
    
    cellside=""
    for i in $(seq 1 $tile_width); do
        cellside="${cellside}${tileborder}"
    done

    printf "$template" "$cellside" "$cellside" "$cellside" "$cellside" "$cellside" "$cellside" "$cellside" "$cellside" "$cellside"
    echo
}

function draw_borders() {
    # Magic happening here!
    top_template='╔%s╤%s╤%s╦%s╤%s╤%s╦%s╤%s╤%s╗'
    mid_tile_template='║%s│%s│%s║%s│%s│%s║%s│%s│%s║'
    between_tiles_template='╟%s┼%s┼%s╫%s┼%s┼%s╫%s┼%s┼%s╢'
    between_blocks_template='╠%s╪%s╪%s╬%s╪%s╪%s╬%s╪%s╪%s╣'
    bottom_template='╚%s╧%s╧%s╩%s╧%s╧%s╩%s╧%s╧%s╝'

    home
    draw_border_template $top_template '═'
    for what in tile tile block tile tile block tile tile bottom; do
        repeat "`draw_border_template $mid_tile_template ' '`" $tile_height
        if [ "$what" = "tile" ]; then
            draw_border_template $between_tiles_template '─'
        elif [ "$what" = "block" ]; then
            draw_border_template $between_blocks_template '═'
        else
            draw_border_template $bottom_template '═'
        fi
    done
}

function draw_grid() {
    move $(( tile_height / 2 + 1 )) $(( tile_width / 2 + 1 )) # Center of the first up-left tile
    for row in {0..8}; do
        for col in {0..8}; do
            echo -n "${grid[row * 9 + col]}"
            right $tile_width # To the center of the next tile
        done
        
        # Jump to the center of the first tile in the next row 
        line_start
        down $(( tile_height + 1 ))
        right $(( tile_width / 2 + 1 ))
    done
}

function draw_field() {
    clear
    draw_borders
    draw_grid
}

function status() {
    move $field_height 0
    echo $@
}
