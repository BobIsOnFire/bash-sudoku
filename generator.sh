##### Sudoku generation engine.

# We can generate endless number of sudokus from a single valid one by:
# 1. Shuffling rows in a single row block
# 2. Shuffling whole row blocks
# 3. Shuffling columns in a single column block
# 4. Shuffling whole column blocks
# 5. Removing some number of tiles
# 6. Checking if it is solvable (?)

function shuffle_rows_in_blocks() {
    for i in {0..2}; do print_row $i ' ' ''; done | shuf
    for i in {3..5}; do print_row $i ' ' ''; done | shuf
    for i in {6..8}; do print_row $i ' ' ''; done | shuf
}

function shuffle_block_rows() {
    (
        for i in {0..2}; do print_row $i ' ' ''; done | xargs
        for i in {3..5}; do print_row $i ' ' ''; done | xargs
        for i in {6..8}; do print_row $i ' ' ''; done | xargs
    ) | shuf
}

function shuffle_grid() {
    grid=( $(shuffle_rows_in_blocks) )
    grid=( $(shuffle_block_rows) )
    grid=( $(print_transposed ' ' '') )
    grid=( $(shuffle_rows_in_blocks) )
    grid=( $(shuffle_block_rows) )
}

# Difficulty modes
case "$difficulty" in
    1|easy)
        tiles_erased=30
        ;;
    2|medium)
        tiles_erased=40
        ;;
    3|hard)
        tiles_erased=50
        ;;
    *)
        echo "Error: unknown difficulty value: $difficulty (expected 1, 'easy', 2, 'medium', 3, or 'hard')" 1>&2
        exit 1
        ;;
esac

function erase_tiles() {
    for i in $(shuf -e {0..80} | head -$tiles_erased); do
        grid[i]=' '
        editable[i]=1
    done
}

# Generator seed - a valid sudoku
seed=`cat <<EOF
7 9 1 6 8 3 2 5 4
8 6 5 4 2 7 9 1 3
2 4 3 9 1 5 6 8 7
9 1 2 7 6 4 5 3 8
4 3 7 5 9 8 1 6 2
5 8 6 1 3 2 4 7 9
6 2 9 8 7 1 3 4 5
1 5 8 3 4 9 7 2 6
3 7 4 2 5 6 8 9 1
EOF
`

function save_grid() {
    filename="$1"; shift
    for row in {0..8}; do
        for col in {0..8}; do
            echo -n ${grid[row * 9 + col]}

            test -z "${editable[row * 9 + col]}"
            echo -n $?

            echo -n ' '
        done
    done >"$filename"
}

function load_grid() {
    filename="$1"; shift
    loaded_str="`cat "$filename"`"
    
    rv=$?
    if [ "$rv" != "0" ]; then
        return $rv
    fi

    loaded=( $loaded_str )
    for row in {0..8}; do
        for col in {0..8}; do
            grid_num=$(( ${loaded[row * 9 + col]} / 10 ))
            editable_num=$(( ${loaded[row * 9 + col]} % 10 ))

            if [ "$grid_num" = "0" ]; then
                grid[row * 9 + col]=' '
            else
                grid[row * 9 + col]="$grid_num"
            fi

            if [ "$editable_num" = "1" ]; then
                editable[row * 9 + col]=1
            fi
        done
    done
}
