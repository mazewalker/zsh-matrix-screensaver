# Configuration
export SCREENSAVER_TIMEOUT=300  # 5 minutes before screensaver triggers
export SCREENSAVER_ENABLED=true

# Idle detection using TMOUT
function start_screensaver() {
    echo "start_screensaver called"
    if [[ -n $(jobs) ]]; then
        echo "Jobs are running, screensaver will not start"
        return
    fi
    
    [[ $SCREENSAVER_ENABLED == true ]] || { echo "Screensaver is disabled"; return; }
    echo "Starting screensaver"
    clear
    ~/.zsh_screensaver.sh
}

# Function to reset TMOUT when input is detected
function reset_idle_timer() {
    TMOUT=$SCREENSAVER_TIMEOUT
}

# Reset timer on any keypress
function zle-keymap-select zle-line-init zle-line-finish {
    reset_idle_timer
}

# Hook into ZSH's input system
autoload -Uz add-zsh-hook
zle -N zle-line-init
zle -N zle-keymap-select
zle -N zle-line-finish

# Set idle timeout
TMOUT=$SCREENSAVER_TIMEOUT
TRAPALRM() { start_screensaver }