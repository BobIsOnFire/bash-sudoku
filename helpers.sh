##### Helper functions.

function print_row() {
    row="$1"; shift
    elem_sep="$1"; shift
    line_sep="$1"; shift

    for i in {0..8}; do 
        echo -ne "${grid[row * 9 + i]}$elem_sep"
    done
    echo -ne "$line_sep"
}

function print_col() {
    col="$1"; shift
    elem_sep="$1"; shift
    line_sep="$1"; shift

    for i in {0..8}; do 
        echo -ne "${grid[i * 9 + col]}$elem_sep"
    done
    echo -ne "$line_sep"
}

function print_grid() {
    elem_sep="$1"; shift
    line_sep="$1"; shift

    for i in {0..8}; do
        print_row $i "$elem_sep" "$line_sep"
    done
}

function print_transposed() {
    elem_sep="$1"; shift
    line_sep="$1"; shift

    for i in {0..8}; do
        print_col $i "$elem_sep" "$line_sep"
    done
}
