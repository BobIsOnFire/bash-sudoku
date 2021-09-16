version="Bash Sudoku v$version_string, Copyright (C) 2021-$year Nikita Akatyev"
usage="Usage: $0 [-d <num> | --difficulty=<num>] [<load_file>]"
controls="\
Game controls:
    H                           In-game help on controls
    WASD or arrow keys          Move into adjacent tile
    1-9                         Put a number into the tile
    X, 0, space or backspace    Clear the tile
    Ctrl-L                      Redraw current game (if something went wrong)
    G                           Save the game
    Q, escape or Ctrl-C         Leave the game\
"

help="\
$version
$usage
Positional arguments:
    load_file                   A file from which saved game should be loaded
Non-positional arguments:
    -h | --help                 Print this help message
    -d <n> | --difficulty=<n>   Set the difficulty level. Supported values:
                   1 or 'easy'  Easy mode (30 tiles to fill)
                 2 or 'medium'  Medium mode (40 tiles to fill)
                   3 or 'hard'  Hard mode (50 tiles to fill)
$controls\
"

POSITIONAL=()
while [ $# -gt 0 ]; do
    key="$1"; shift

    case "$key" in
        -d)
            difficulty="$1"; shift
            ;;
        --difficulty=*)
            difficulty="`echo $key | sed 's/--difficulty=//g'`"
            ;;
        -h|--help)
            echo "$help"
            exit
            ;;
        -v|--version)
            echo "$version"
            exit
            ;;
        *)
            POSITIONAL+=("$key")
            ;;
    esac
done

set -- "${POSITIONAL[@]}"
load_file=$1

if [ -z "$difficulty" ]; then
    difficulty=1
fi
