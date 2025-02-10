#!/bin/zsh

# Matrix Digital Rain Screensaver
# Handles terminal resize, cleanup, and smooth animation

# Cleanup function
cleanup() {
    tput cnorm   # Show cursor
    tput rmcup   # Restore screen
    tput sgr0    # Reset colors
    clear
    exit 0
}

# Set up trap for clean exit
trap cleanup INT TERM

# Save current screen and hide cursor
tput smcup
tput civis

# Get terminal size
TERM_WIDTH=$(tput cols)
TERM_HEIGHT=$(tput rows)

# Initialize arrays
typeset -A matrix_data
typeset -a streams speeds positions
# Matrix characters (expanded set)
CHARS=(ｱ ｲ ｳ ｴ ｵ ｶ ｷ ｸ ｹ ｺ ｻ ｼ ｽ ｾ ｿ ﾀ ﾁ ﾂ ﾃ ﾄ ﾅ ﾆ ﾇ ﾈ ﾉ ﾊ ﾋ ﾌ ﾍ ﾎ ﾏ ﾐ ﾑ ﾒ ﾓ ﾔ ﾕ ﾖ ﾗ ﾘ ﾙ ﾚ ﾛ ﾜ ﾝ 0 1 2 3 4 5 6 7 8 9 @ # $ % & * + - = ? !)

# Initialize matrix streams
# trunk-ignore(shfmt/parse)
init_streams() {
    local i
    for ((i=0; i<TERM_WIDTH; i++)); do
        if (( RANDOM % 3 == 0 )); then
            streams[$i]=""
            speeds[$i]=$((RANDOM % 3 + 1))
            positions[$i]=0
            matrix_data[$i,stream]=""
            matrix_data[$i,speed]=$((RANDOM % 3 + 1))
            matrix_data[$i,position]=0
        fi
    done
}

# Update stream positions and characters
update_streams() {
    local i char
    for i in "${!streams[@]}"; do
        # Update position
        ((positions[$i]+=speeds[$i]))
        
        # Reset stream if it reaches bottom
        ((matrix_data[$i,position]+=matrix_data[$i,speed]))
        
        # Reset stream if it reaches bottom
        if ((matrix_data[$i,position] >= TERM_HEIGHT)); then
            matrix_data[$i,position]=0
            matrix_data[$i,speed]=$((RANDOM % 3 + 1))
            matrix_data[$i,stream]=""
        char=${CHARS[$RANDOM % ${#CHARS[@]}]}
        streams[$i]+="$char"
        
        # Trim stream if too long
        matrix_data[$i,stream]+="$char"

        # Trim stream if too long
        if ((${#matrix_data[$i,stream]} > TERM_HEIGHT)); then
            matrix_data[$i,stream]=${matrix_data[$i,stream]:1}

# Draw matrix effect
draw_matrix() {
    local i j char
    clear
    
    for i in "${!streams[@]}"; do
        local stream=${streams[$i]}
        local pos=${positions[$i]}
    for i in "${(@k)matrix_data}"; do
        [[ $i == *,stream ]] || continue
        i=${i%,stream}
        local stream=${matrix_data[$i,stream]}
        local pos=${matrix_data[$i,position]}
        for ((j=0; j<len; j++)); do
            local y=$((pos-j))
            if ((y >= 0 && y < TERM_HEIGHT)); then
                char=${stream:j:1}
                
                # First character (bright white)
                if ((j == 0)); then
                    tput cup $y $i
                    echo -en "\033[1;37m$char"
                # Next few characters (bright green)
                elif ((j < 3)); then
                    tput cup $y $i
                    echo -en "\033[1;32m$char"
                # Rest of characters (dark green, fading)
                else
                    local fade=$((j * 2))
                    if ((fade > 7)); then fade=7; fi
                    tput cup $y $i
                    echo -en "\033[0;32m$char"
                fi
            fi
        done
    done
}

# Main loop
init_streams

while true; do
    # Check if terminal size changed
    local new_width=$(tput cols)
    local new_height=$(tput rows)
    
    if ((new_width != TERM_WIDTH || new_height != TERM_HEIGHT)); then
        TERM_WIDTH=$new_width
        TERM_HEIGHT=$new_height
        init_streams
    fi
    
    update_streams
    draw_matrix
    
    # Control animation speed
    sleep 0.1
done