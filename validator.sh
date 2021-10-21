##### Sudoku solution checker engine.

function check_row() {
    row=$1; shift
    for i in {1..9}; do
        checker[i]=0
    done

    for col in {0..8}; do
        i=${grid[row * 9 + col]}
        checker[i]=$(( ${checker[i]} + 1 ))
    done

    for i in {1..9}; do
        [ "${checker[i]}" = "1" ] || return 1
    done

    return 0
}

function check_col() {
    col=$1; shift
    for i in {1..9}; do
        checker[i]=0
    done

    for row in {0..8}; do
        i=${grid[row * 9 + col]}
        checker[i]=$(( ${checker[i]} + 1 ))
    done

    for i in {1..9}; do
        [ "${checker[i]}" = "1" ] || return 1
    done

    return 0
}

function check_block() {
    block=$1; shift
    for i in {1..9}; do
        checker[i]=0
    done

    for cell in {0..8}; do
        row=$(( block / 3 * 3 + cell / 3 ))
        col=$(( block % 3 * 3 + cell % 3 ))
        i=${grid[row * 9 + col]}
        checker[i]=$(( ${checker[i]} + 1 ))
    done

    for i in {1..9}; do
        [ "${checker[i]}" = "1" ] || return 1
    done

    return 0
}

function check_finished() {
    for check in {0..8}; do
        ( check_row $check && check_col $check && check_block $check ) || return 1
    done

    return 0
}
