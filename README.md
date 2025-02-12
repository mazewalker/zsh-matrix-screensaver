# ZSH Matrix Screensaver

[![Lint Code Base](https://github.com/mazewalker/zsh-matrix-screensaver/actions/workflows/super-linter.yml/badge.svg)](https://github.com/mazewalker/zsh-matrix-screensaver/actions/workflows/super-linter.yml)

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
export SCREENSAVER_TIMEOUT=120  # 2 minutes
export SCREENSAVER_ENABLED=true
```

## Usage

The screensaver will automatically start after the configured idle timeout.

- Toggle on/off: `export SCREENSAVER_ENABLED=true/false`
- Adjust timeout: `export SCREENSAVER_TIMEOUT=300`

## Plugin Management

### Updating the Plugin

To update the plugin to the latest version:

```zsh
zinit update mazewalker/zsh-matrix-screensaver
```

Then restart your terminal or source your `.zshrc`:
```zsh
source ~/.zshrc
```

### Unloading the Plugin

To temporarily disable the plugin in your current session:

```zsh
zinit unload mazewalker/zsh-matrix-screensaver
```

### Removing the Plugin

To completely remove the plugin:

1. First, remove the plugin line from your `.zshrc`:
```zsh
# Remove or comment out this line:
# zinit light mazewalker/zsh-matrix-screensaver
```

2. Then remove the plugin files:
```zsh
zinit delete mazewalker/zsh-matrix-screensaver
```

3. Finally, restart your terminal or source your `.zshrc`:
```zsh
source ~/.zshrc
```

## License

MIT License
