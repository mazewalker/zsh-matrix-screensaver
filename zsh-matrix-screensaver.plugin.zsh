# Configuration
export SCREENSAVER_TIMEOUT=120  # 2 minutes before screensaver triggers
export SCREENSAVER_ENABLED=true
export LAST_ACTIVITY=$(date +%s)

# Function to reset TMOUT when input is detected
function reset_idle_timer() {
    LAST_ACTIVITY=$(date +%s)
    TMOUT=$SCREENSAVER_TIMEOUT
    # Debug line to verify timer reset (optional, remove in production)
    # echo "Timer reset: $(date +%H:%M:%S)"
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
    # Only start if no command is currently running
    if [[ -n $(jobs) ]]; then
        reset_idle_timer
        return
    fi
    
    [[ $SCREENSAVER_ENABLED == true ]] || { return; }
    clear
    ${0:A:h}/.zsh_screensaver.sh
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
    else
        # Reset timer for next check
        TMOUT=$((SCREENSAVER_TIMEOUT - idle_time))
    fi
}