#!/bin/bash
set -e

# Colors
GREEN='\033[0;32m'
NC='\033[0m'

# Paths
DOTFILES_DIR="$HOME/dotfiles"
ZSHRC_SOURCE="$DOTFILES_DIR/.zshrc"
P10K_SOURCE="$DOTFILES_DIR/.p10k.zsh"
ZSHRC_TARGET="$HOME/.zshrc"
P10K_TARGET="$HOME/.p10k.zsh"
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$OH_MY_ZSH_DIR/custom"
P10K_DIR="$ZSH_CUSTOM/themes/powerlevel10k"

# Help message
show_help() {
  echo "Usage: $0 [install|cleanup|help]"
  echo
  echo "  install      Install Zsh, Oh My Zsh, Powerlevel10k, and dotfiles"
  echo "  cleanup      Restore Bash and completely remove Zsh and customizations"
  echo "  help         Show this message"
}

do_install() {
  echo -e "${GREEN}Installing Zsh, Oh My Zsh, and Powerlevel10k...${NC}"

  if ! command -v zsh &> /dev/null; then
    echo "Zsh not found. Installing..."
    sudo apt update && sudo apt install -y zsh
  else
    echo "Zsh is already installed."
  fi

  if [[ "$SHELL" != "$(command -v zsh)" ]]; then
    echo "Changing default shell to Zsh..."
    chsh -s "$(command -v zsh)"
  fi

  if [ ! -d "$OH_MY_ZSH_DIR" ]; then
    echo "Installing Oh My Zsh..."
    RUNZSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    echo "Oh My Zsh is already installed."
  fi

  if [ ! -d "$P10K_DIR" ]; then
    echo "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
  else
    echo "Powerlevel10k already installed."
  fi

  echo "Linking .zshrc and .p10k.zsh..."
  ln -sf "$ZSHRC_SOURCE" "$ZSHRC_TARGET"
  ln -sf "$P10K_SOURCE" "$P10K_TARGET"

  echo -e "${GREEN}✅ Installation complete. Launching Zsh...${NC}"
  exec zsh
}

do_cleanup() {
  echo -e "${GREEN}Cleaning up Zsh, Oh My Zsh, Powerlevel10k...${NC}"

  # Change back to Bash shell
  if [[ "$SHELL" != "/bin/bash" ]]; then
    echo "Switching default shell back to Bash..."
    chsh -s /bin/bash
  fi

  # Remove Oh My Zsh and Powerlevel10k
  rm -rf "$OH_MY_ZSH_DIR"
  rm -rf "$P10K_DIR"

  # Remove config files
  rm -f "$ZSHRC_TARGET" "$P10K_TARGET" "$HOME/.zsh_history" "$HOME/.zshrc.pre-oh-my-zsh"

  # Uninstall Zsh
  if command -v zsh &> /dev/null; then
    echo "Uninstalling Zsh..."
    sudo apt remove --purge -y zsh
    sudo apt autoremove -y
  fi

  echo -e "${GREEN}✅ Cleanup complete. Restart terminal to use Bash.${NC}"
}

# Main command routing
case "$1" in
  install)
    do_install
    ;;
  cleanup)
    do_cleanup
    ;;
  help|*)
    show_help
    ;;
esac

