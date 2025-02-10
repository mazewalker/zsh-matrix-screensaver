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

## License
MIT License
