# ZSH Matrix Screensaver

[![Lint Code Base](https://github.com/mazewalker/zsh-matrix-screensaver/actions/workflows/super-linter.yml/badge.svg)](https://github.com/mazewalker/zsh-matrix-screensaver/actions/workflows/super-linter.yml)

A customizable Matrix-style terminal screensaver for ZSH.

## Complete Setup Guide

### Prerequisites

#### macOS
```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install ZSH
brew install zsh

# Set ZSH as default shell
chsh -s $(which zsh)
```

#### Linux (Ubuntu/Debian)
```bash
# Install ZSH
sudo apt update
sudo apt install zsh

# Set ZSH as default shell
chsh -s $(which zsh)
```

#### Linux (Fedora)
```bash
# Install ZSH
sudo dnf install zsh

# Set ZSH as default shell
chsh -s $(which zsh)
```

#### Windows (WSL)
```bash
# Install WSL if not already installed
wsl --install

# Install ZSH in WSL
sudo apt update
sudo apt install zsh

# Set ZSH as default shell
chsh -s $(which zsh)
```

### Install Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Install Zinit

```bash
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
```

### Configure Your `.zshrc`

```bash
# filepath: ~/.zshrc
# Load Zinit
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

# Essential plugins
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# Install Spaceship prompt
zinit light spaceship-prompt/spaceship-prompt

# Matrix Screensaver
zinit light csiszi/zsh-matrix-screensaver

# Screensaver configuration
export SCREENSAVER_TIMEOUT=120  # 2 minutes
export SCREENSAVER_ENABLED=true
```

### Install Additional Tools (Optional)

#### macOS
```bash
# Install ASDF
brew install asdf

# Add ASDF to ZSH
echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ~/.zshrc
```

#### Linux/WSL
```bash
# Install ASDF
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1

# Add ASDF to ZSH
echo '. "$HOME/.asdf/asdf.sh"' >> ~/.zshrc
```

### Final Steps

```bash
# Apply changes
source ~/.zshrc

# Verify Zinit installation
zinit self-update
```

Your ZSH environment is now set up with:
- Oh My Zsh for plugin management
- Zinit for fast plugin loading
- Spaceship prompt for a modern look
- Matrix screensaver for style
- ASDF for version management
- Syntax highlighting and autosuggestions

## Plugin Management

### Updating the Plugin

To update the plugin to the latest version:

```zsh
zinit update mazewalker/zsh-matrix-screensaver
source ~/.zshrc
```

### Unloading the Plugin

To temporarily disable the plugin in your current session:

```zsh
zinit unload mazewalker/zsh-matrix-screensaver
```

### Removing the Plugin

To completely remove the plugin:

```zsh
zinit delete mazewalker/zsh-matrix-screensaver
source ~/.zshrc
```

## Font Installation Guide

### Installing Nerd Fonts

#### macOS
```bash
# Install with Homebrew
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
# or
brew install --cask font-roboto-mono-nerd-font
```

#### Linux (Ubuntu/Debian)
```bash
# Download and install fonts manually
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "Hack Regular Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf
# Refresh font cache
fc-cache -fv
```

#### Windows (WSL)
```powershell
# Run in PowerShell as Administrator
winget install JanDeDobbeleer.OhMyPosh -s winget
# or download manually from the Nerd Fonts releases page
```

### Terminal Configuration

#### VS Code
1. Open Settings (Cmd+, on macOS, Ctrl+, on Windows/Linux)
2. Search for "terminal font"
3. Add to `settings.json`:
```json
{
    "terminal.integrated.fontFamily": "Hack Nerd Font"
}
```

#### iTerm2 (macOS)
1. Open Preferences (Cmd+,)
2. Go to Profiles > Text
3. Select "Hack Nerd Font" from Font dropdown

#### GNOME Terminal (Linux)
1. Right-click in terminal > Preferences
2. Select your profile
3. Check "Custom font"
4. Select "Hack Nerd Font"

#### Windows Terminal
1. Open Settings (Ctrl+,)
2. Click on your profile
3. Under "Appearance"
4. Set "Font face" to "Hack Nerd Font"

### Verifying Font Installation

Test if the font is working by checking if these icons render properly:
```bash
echo "\ue0b0 \ue0b1 \ue0b2 \ue0b3"
```

You should see special characters instead of boxes or question marks.

## Debugging

### Enabling Debug Mode

Add to your `.zshrc` to enable debug mode:

```bash
# Enable debug logging
export MATRIX_SCREENSAVER_DEBUG=true
```

### Debug Log Location

Debug logs are written to `/tmp/matrix-screensaver-debug.log`. You can:

```bash
# Monitor debug output in real-time
tail -f /tmp/matrix-screensaver-debug.log
```

### Available Debug Information

The debug log includes:
- Timestamp for each entry
- Segment initialization details
- Terminal size information
- Input detection events
- Animation frame updates
- Cleanup operations
- Error conditions

### Debug Log Format

Each log entry follows this format:
```
[YYYY-MM-DD HH:MM:SS] Message
```

Example log entries:
```
[2025-02-16 10:30:15] Debug logging initialized
[2025-02-16 10:30:15] Initializing segments with TERM_WIDTH: 80, TERM_HEIGHT: 24
[2025-02-16 10:30:15] Added new segment in column 5: stream='ｱｲｳ' (len=3), speed=2, pos=-1
```

### Troubleshooting Common Issues

1. **No Debug Output**
   - Verify debug mode is enabled: `echo $MATRIX_SCREENSAVER_DEBUG`
   - Check log file permissions: `ls -l /tmp/matrix-screensaver-debug.log`
   - Ensure log directory is writable: `touch /tmp/test && rm /tmp/test`

2. **Screen Not Clearing Properly**
   ```bash
   # Check if terminal supports alternate buffer
   echo $TERM
   # Should be xterm-256color or similar
   ```

3. **Input Detection Issues**
   ```bash
   # Verify terminal settings
   stty -a
   ```

4. **Font Problems**
   ```bash
   # Test character rendering
   echo -e "\033[1;32mMatrix Test\033[0m"
   ```

### Development Tips

- Set `SCREENSAVER_TIMEOUT=5` for faster testing
- Use `MATRIX_SCREENSAVER_DEBUG=true` during development
- Monitor logs in a separate terminal window
- Test in different terminal emulators
- Check terminal capabilities with `infocmp`

## License

MIT License
