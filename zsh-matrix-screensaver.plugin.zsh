0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Add plugin's bin directory to path
path+=("${0:h}/bin")

# Configuration
: ${SCREENSAVER_TIMEOUT:=300}  # Default 5 minutes
: ${SCREENSAVER_ENABLED:=true}

# Idle detection using TMOUT
function start_screensaver() {
    # Don't trigger if there's ongoing output
    if [[ -n $(jobs) ]]; then
        return
    }
    
    [[ $SCREENSAVER_ENABLED == true ]] || return
    clear
    matrix-screensaver
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
