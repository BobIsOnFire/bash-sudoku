##### User input engine.

key_up=$'\e[A'
key_up_alt=$'\e0A'

key_down=$'\e[B'
key_down_alt=$'\e0B'

key_left=$'\e[D'
key_left_alt=$'\e0D'

key_right=$'\e[C'
key_right_alt=$'\e0C'

key_space=$'\x20'
key_backspace=$'\x7f'
key_escape=$'\e'
key_clear=$'\x0C'

function listen_key() {
    # -s so that input will not echo
    read -sN1 k
    # For multi-key sequences sent by one press (like arrow keys)
    read -sN1 -t 0.0001 k1
    read -sN1 -t 0.0001 k2
    read -sN1 -t 0.0001 k3

    echo "$k$k1$k2$k3"
}
