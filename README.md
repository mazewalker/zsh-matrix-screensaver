[![Lint Code Base](https://github.com/mazewalker/zsh-matrix-screensaver/actions/workflows/super-linter.yml/badge.svg)](https://github.com/mazewalker/zsh-matrix-screensaver/actions/workflows/super-linter.yml)
# ZSH Matrix Screensaver

A customizable Matrix-style terminal screensaver for ZSH.

## Installation

### Using zinit
```zsh
zinit light mazewalker/zsh-matrix-screensaver
```

### Configuration
Add to your `.zshrc`:
```zsh
# Optional: customize settings
export SCREENSAVER_TIMEOUT=300  # 5 minutes
export SCREENSAVER_ENABLED=true
```

## Usage
The screensaver will automatically start after the configured idle timeout.
- Toggle on/off: `export SCREENSAVER_ENABLED=true/false`
- Adjust timeout: `export SCREENSAVER_TIMEOUT=300`

## Uninstallation

```zsh
zinit unload mazewalker/zsh-matrix-screensaver    # (optional) Unload it from the current session
zinit delete mazewalker/zsh-matrix-screensaver    # Delete it from disk
zinit light mazewalker/zsh-matrix-screensaver     # Reinstall the plugin
```

## License
MIT License
