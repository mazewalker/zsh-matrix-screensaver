#!/bin/zsh

# Contents of zsh-matrix-screensaver.plugin.zsh
DEBUG=false

function cleanup {
    printf "\033[?1049l"    # Return from alternate screen buffer
    printf "\033[?7h"       # Re-enable line wrapping
    printf "\033[?1000l"    # Disable mouse reporting
    tput cnorm             # Show cursor
    tput sgr0              # Reset colors
}

trap cleanup INT TERM

# New helper: check if any key or mouse event is detected and quit immediately.
function check_quit {
    if read -t 0 -n 1 key; then
        debug_info "Key or mouse event detected (inner loop), cleaning up..."
        cleanup
        exit 0  # Ensure the script exits after cleanup
    fi
}

# Switch to alternate screen buffer and save current screen
printf "\033[?1049h"    # Switch to alternate screen buffer
printf "\033[?7l"       # Disable line wrapping
tput civis             # Hide cursor

# Enable mouse reporting for click events
printf "\033[?1000h"

# Get terminal size
TERM_WIDTH=$(tput cols)
TERM_HEIGHT=$(tput lines)

# Introduce a global segments array:
segments=()

# Matrix characters (expanded set)
CHARS=(
    'ｱ' 'ｲ' 'ｳ' 'ｴ' 'ｵ' 'ｶ' 'ｷ' 'ｸ' 'ｹ' 'ｺ' 'ｻ' 'ｼ' 'ｽ' 'ｾ' 'ｿ'
    'ﾀ' 'ﾁ' 'ﾂ' 'ﾃ' 'ﾄ' 'ﾅ' 'ﾆ' 'ﾇ' 'ﾈ' 'ﾉ' 'ﾊ' 'ﾋ' 'ﾌ' 'ﾍ' 'ﾎ'
    'ﾏ' 'ﾐ' 'ﾑ' 'ﾒ' 'ﾓ' 'ﾔ' 'ﾕ' 'ﾖ' 'ﾗ' 'ﾘ' 'ﾙ' 'ﾚ' 'ﾛ' 'ﾜ' 'ﾝ'
    '0' '1' '2' '3' '4' '5' '6' '7' '8' '9'
    '@' '#' '$' '%' '&' '*' '+' '-' '=' '?' '!'
)

function init_segments {
    debug_info "Initializing segments with TERM_WIDTH: $TERM_WIDTH, TERM_HEIGHT: $TERM_HEIGHT"
    segments=()
    for (( col=0; col<TERM_WIDTH; col++ )); do
        check_quit  # Listen for event during initialization
        local len=$(( RANDOM % 5 + 3 ))  # Random length between 3-7 characters
        local stream=""
        for (( j=0; j<len; j++ )); do
            stream+=${CHARS[$(( (RANDOM % ${#CHARS[@]}) ))]}
        done
        local speed=$(( RANDOM % 3 + 1 ))
        local pos=$(( (RANDOM % TERM_HEIGHT) * -1 - 1 ))
        segments+=( "$col:$pos:$speed:$stream" )
        debug_info "Initialized column $col: stream='$stream' (len=${#stream}), speed=$speed, pos=$pos"
    done
    debug_info "Initialization complete. Total segments: ${#segments[@]}"
}

function debug_info {
    if [[ "$DEBUG" == "true" ]]; then
        echo "$1" >&2
    fi
}

function update_segments {
    debug_info "Updating segments..."
    local new_segments=()
    local IFS=":"  # use colon as delimiter
    for seg in "${segments[@]}"; do
        check_quit  # Check at each iteration
        # Split seg into col, pos, speed, and stream
        read -r col pos speed stream <<< "$seg"
        pos=$(( pos + speed ))
        if (( pos - ${#stream} < TERM_HEIGHT )); then
            new_segments+=( "$col:$pos:$speed:$stream" )
        else
            debug_info "Segment in column $col removed (went off screen)"
        fi
    done
    segments=("${new_segments[@]}")

    # For each column, randomly add a new segment (30% chance)
    for (( col=0; col<TERM_WIDTH; col++ )); do
        check_quit
        if (( RANDOM % 10 < 3 )); then
            local stream=""  # declare once for both branches
            # Occasionally (10% chance) add a gap segment instead of normal characters
            if (( RANDOM % 100 < 10 )); then
                local gap_max=$(( TERM_HEIGHT / 5 ))
                (( gap_max < 1 )) && gap_max=1
                local gap_len=$(( RANDOM % gap_max + 1 ))
                # Create a string of spaces (gap segment)
                stream=$(printf "%*s" "$gap_len" "")
            else
                local max_len=$(( TERM_HEIGHT / 3 ))
                (( max_len < 2 )) && max_len=2
                local len=$(( RANDOM % (max_len - 2 + 1) + 3 ))
                for (( j=0; j<len; j++ )); do
                    stream+=${CHARS[$(( (RANDOM % ${#CHARS[@]}) ))]}
                done
            fi
            local speed=$(( RANDOM % 3 + 1 ))
            local pos=$(( RANDOM % 5 * -1 - 1 ))  # start just above the screen
            segments+=( "$col:$pos:$speed:$stream" )
            debug_info "Added new segment in column $col: stream='$stream' (len=${#stream}), speed=$speed, pos=$pos"
        fi
    done
}

function draw_matrix {
    # Move cursor to top left
    printf "\033[H"
    local IFS=":"  # for splitting segments
    for seg in "${segments[@]}"; do
        check_quit  # Check before processing each segment
        read -r col pos speed stream <<< "$seg"
        local len=${#stream}
        for (( j=0; j<len && j<TERM_HEIGHT; j++ )); do
            check_quit  # Check before drawing each character
            local y=$(( pos - j ))
            if (( y >= 0 && y < TERM_HEIGHT )); then
                local char=${stream:$((j)):1}
                tput cup $y $col
                if (( j == 0 )); then
                    echo -en "\033[1;37m$char"  # White lead
                elif (( j < 3 )); then
                    echo -en "\033[1;32m$char"  # Bright green trail
                else
                    echo -en "\033[0;32m$char"  # Normal green tail
                fi
            fi
        done
    done
}

function start {
    init_segments

    while true; do
        {
            if read -t 0 -n 1 key; then
                debug_info "Key or mouse event detected, cleaning up..."
                cleanup
                break
            fi

            local new_width=$(tput cols)
            local new_height=$(tput lines)

            if (( new_width != TERM_WIDTH || new_height != TERM_HEIGHT )); then
                TERM_WIDTH=$new_width
                TERM_HEIGHT=$new_height
                debug_info "Terminal size changed: ${TERM_WIDTH}x${TERM_HEIGHT}"
                init_segments
                printf "\033[2J" # Clear the screen on resize
            fi

            update_segments
            draw_matrix

            # Small sleep to control frame rate
            sleep 0.03
        } || {
            debug_info "Caught error, continuing..."
            continue
        }
    done
    cleanup  # Ensure cleanup is called after exiting the loop
}

function reset_idle_timer() {
    LAST_ACTIVITY=$(date +%s)
    TMOUT=$SCREENSAVER_TIMEOUT
}

# Capture all keyboard input events
function preexec() {
    reset_idle_timer
}

# Reset timer on prompt display
function precmd() {
    reset_idle_timer
}

# Reset timer on any ZLE event
function zle-line-init zle-keymap-select zle-line-finish zle-line-pre-redraw {
    reset_idle_timer
}

# Idle detection using TMOUT
function start_screensaver() {
    if [[ -n $(jobs) ]]; then
        reset_idle_timer
        return
    fi
    
    [[ $SCREENSAVER_ENABLED == true ]] || { return; }
    clear
    start  # Call the start function instead of executing the script
}

# Hook into ZSH's input system
autoload -Uz add-zsh-hook
add-zsh-hook preexec preexec
add-zsh-hook precmd precmd
zle -N zle-line-init
zle -N zle-keymap-select
zle -N zle-line-finish
zle -N zle-line-pre-redraw

# Set initial idle timeout
TMOUT=$SCREENSAVER_TIMEOUT
TRAPALRM() {
    current_time=$(date +%s)
    idle_time=$((current_time - LAST_ACTIVITY))

    if ((idle_time >= SCREENSAVER_TIMEOUT)); then
        start_screensaver
        cleanup  # Ensure cleanup is called after the screensaver starts and exits
    else
        TMOUT=$((SCREENSAVER_TIMEOUT - idle_time))
    fi
}

# Initialize the last activity time
LAST_ACTIVITY=$(date +%s)