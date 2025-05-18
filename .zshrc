# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set the Zsh theme (optional: you can change the theme later)
ZSH_THEME="powerlevel10k/powerlevel10k"

# Enable some basic plugins (you can add more later)
plugins=(
  git
)

# Source the Oh My Zsh installation (you can enable more features later)
source $ZSH/oh-my-zsh.sh

# History settings (you can expand this as you go)
HISTSIZE=1000
SAVEHIST=1000
HISTFILE="$HOME/.zsh_history"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
