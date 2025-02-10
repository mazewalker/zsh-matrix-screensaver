0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Add plugin's bin directory to path
plugin_dir="${0:h}"
export PATH="$plugin_dir/bin:$PATH"

# Configuration with debug logging
: ${SCREENSAVER_TIMEOUT:=300}
: ${SCREENSAVER_ENABLED:=true}

# Debug function
debug_log() {
    echo "[Matrix Debug] $1" >&2
}

debug_log "Plugin loaded from: $plugin_dir"
debug_log "PATH is now: $PATH"

# Idle detection using TMOUT
start_screensaver() {
    debug_log "Screensaver trigger attempted"
    debug_log "Jobs: $(jobs)"
    debug_log "SCREENSAVER_ENABLED: $SCREENSAVER_ENABLED"
    
    # Don't trigger if there's ongoing output
    if [[ -n $(jobs) ]]; then
        debug_log "Jobs running, skipping screensaver"
        return
    fi
    
    if [[ $SCREENSAVER_ENABLED != true ]]; then
        debug_log "Screensaver disabled, skipping"
        return
    fi
    
    debug_log "Starting screensaver"
    clear
    if command -v matrix-screensaver >/dev/null 2>&1; then
        debug_log "Found matrix-screensaver in PATH"
        matrix-screensaver
    else
        debug_log "matrix-screensaver not found in PATH"
        debug_log "Current PATH: $PATH"
        debug_log "Looking for script in: $plugin_dir/bin/matrix-screensaver"
        if [[ -x "$plugin_dir/bin/matrix-screensaver" ]]; then
            debug_log "Found executable at $plugin_dir/bin/matrix-screensaver"
            "$plugin_dir/bin/matrix-screensaver"
        else
            debug_log "Screensaver script not found or not executable"
        fi
    fi
}

reset_idle_timer() {
    debug_log "Resetting idle timer to $SCREENSAVER_TIMEOUT"
    TMOUT=$SCREENSAVER_TIMEOUT
}

zle-keymap-select zle-line-init zle-line-finish() {
    debug_log "Key event detected"
    reset_idle_timer
}

# Hook into ZSH's input system
autoload -Uz add-zsh-hook
zle -N zle-line-init
zle -N zle-keymap-select
zle -N zle-line-finish

# Set idle timeout with debug
debug_log "Setting initial TMOUT to $SCREENSAVER_TIMEOUT"
TMOUT=$SCREENSAVER_TIMEOUT

# Define TRAPALRM with debug
TRAPALRM() {
    debug_log "TRAPALRM triggered"
    start_screensaver
}