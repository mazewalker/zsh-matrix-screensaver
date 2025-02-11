#!/bin/zsh

function cleanup {
    printf "\033[?1049l"    # Return from alternate screen buffer
    printf "\033[?7h"       # Re-enable line wrapping
    tput cnorm             # Show cursor
    tput sgr0             # Reset colors
    exit 0
}

trap cleanup INT TERM

# Switch to alternate screen buffer and save current screen
printf "\033[?1049h"    # Switch to alternate screen buffer
printf "\033[?7l"       # Disable line wrapping
tput civis             # Hide cursor

# Get terminal size
TERM_WIDTH=$(tput cols)
TERM_HEIGHT=$(tput lines)

# Initialize streams arrays
declare -A streams
declare -A speeds
declare -A positions

# Matrix characters (expanded set)
CHARS=(ｱ ｲ ｳ ｴ ｵ ｶ ｷ ｸ ｹ ｺ ｻ ｼ ｽ ｾ ｿ ﾀ ﾁ ﾂ ﾃ ﾄ ﾅ ﾆ ﾇ ﾈ ﾉ ﾊ ﾋ ﾌ ﾍ ﾎ ﾏ ﾐ ﾑ ﾒ ﾓ ﾔ ﾕ ﾖ ﾗ ﾘ ﾙ ﾚ ﾛ ﾜ ﾝ 0 1 2 3 4 5 6 7 8 9 @ # $ % & * + - = ? !)

function init_streams {
    local i
    for (( i=0; i<TERM_WIDTH; i++ )); do
        streams[$i]=""
        speeds[$i]=$((RANDOM % 3 + 1))
        positions[$i]=$((RANDOM % TERM_HEIGHT * -1))  # Start above the screen
    done
}

function update_streams {
    local i char
    for i in "${(k)streams}"; do
        (( positions[$i] += speeds[$i] ))
        if (( positions[$i] >= TERM_HEIGHT )); then
            if (( RANDOM % 10 == 0 )); then
                positions[$i]=$(( RANDOM % TERM_HEIGHT * -1 ))
                speeds[$i]=$(( RANDOM % 3 + 1 ))
                streams[$i]=""
            else
                positions[$i]=0
            fi
        fi
        char=${CHARS[$RANDOM % ${#CHARS[@]}]}
        streams[$i]+="$char"
        if ((${#streams[$i]} > TERM_HEIGHT)); then
            streams[$i]="${streams[$i]:1}" # Use parameter expansion instead of sed
        fi
    done
}

function draw_matrix {
    local i j char
    # Move cursor to top-left so we overwrite previous output
    tput cup 0 0
    for i in "${(k)streams}"; do
        local stream=${streams[$i]}
        local pos=${positions[$i]}
        local len=${#stream}
        for (( j=0; j<len; j++ )); do
            local y=$(( pos - j ))
            if (( y >= 0 && y < TERM_HEIGHT )); then
                char=${stream:j:1}
                if (( j == 0 )); then
                    tput cup $y $i
                    echo -en "\033[1;37m$char"
                elif (( j < 3 )); then
                    tput cup $y $i
                    echo -en "\033[1;32m$char"
                else
                    local fade=$(( j * 2 ))
                    (( fade > 7 )) && fade=7
                    tput cup $y $i
                    echo -en "\033[0;32m$char"
                fi
            fi
        done
    done
}

init_streams

# Hide cursor, clear screen, disable line wrap, use alternate screen buffer
tput civis
printf "\033[2J"    # Clear screen
printf "\033[?7l"   # Disable line wrap
printf "\033[?47h"  # Use alternate screen buffer

while true; do
    # Exit immediately if any key is pressed
    if read -t 0 -n 1 key; then
        cleanup
    fi

    local new_width=$(tput cols)
    local new_height=$(tput lines)
    
    if (( new_width != TERM_WIDTH || new_height != TERM_HEIGHT )); then
        TERM_WIDTH=$new_width
        TERM_HEIGHT=$new_height
        init_streams
    fi
    
    update_streams
    draw_matrix
    sleep 0.1
done