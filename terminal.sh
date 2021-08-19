##### Terminal movement engine.

function up() {
    tput cuu $1
}

function down() {
    tput cud $1
}

function left() {
    tput cub $1
}

function right() {
    tput cuf $1
}

function line_start() {
    tput cr
}

function move() {
    tput cup $1 $2
}

function home() {
    move 0 0
}

function clear_row() {
    tput el
}

function clear_screen() {
    tput ed
}

function clear() {
    home
    tput clear
}

##### Terminal color engine.

# TODO: Support 16-bit or true (24-bit) colors
c_black=0
c_red=1
c_green=2
c_yellow=3
c_blue=4
c_magenta=5
c_cyan=6
c_white=7

# Defaults
# TODO: Someone might use a white-bg black-fg terminal, then our defaults do not make any sense
# Maybe tput supports checking them
default_forecolor=$c_white
default_backcolor=$c_black

sudoku_nums_color=$c_magenta

function set_sudoku_nums_colors() {
    tput setab $default_backcolor
    tput setaf $sudoku_nums_color
}

function reset_colors() {
    tput setab $default_backcolor
    tput setaf $default_forecolor
}
