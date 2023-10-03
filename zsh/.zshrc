plugins=(
git
sudo
history
zsh-autosuggestions
fzf
zsh-syntax-highlighting
nvm
poetry
yarn
web-search
rake
last-working-dir
bundler
dotenv
extract)


ZSH_DISABLE_COMPFIX=true

# Pokemon
pokemon-colorscripts -r --no-title

# Zsh zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Zsh zsh-syntax-highlighting
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# exa ls configurations
alias l='exa --icons'
# alias l='exa -ons'
alias ls='exa --icons'
alias la='exa --icons -a'
alias lf='exa --icons -a -F'
alias ld='exa --icons -a -d'
alias lt='exa --icons -a -T'
alias lr='exa --icons -a -r'

alias ll='exa --icons -1'
alias lla='exa --icons -a -1'
alias lfl='exa --icons -a -F -l'
alias ldl='exa --icons -a -d -l'
alias ltl='exa --icons -a -T -l'
alias lrl='exa --icons -a -T -l'

alias lh='exa --icons -h'


# yay config
alias search="yay -Slq | fzf -m --preview 'cat <(yay -Si {1}) <(yay -Fl {1} | \"{print \$2}\")' | xargs -ro yay -S" 

# Clipboard alias
alias clipboard="xclip -sel clip"

# Custom aliases
alias cls='clear'
alias c='clear'
alias mk='mkdir'

# For zoxide
eval "$(zoxide init zsh --cmd cd)"

# windows application aliases
alias files="explorer.exe ."
alias winget="winget.exe"
alias choco="choco.exe"
alias cmd="cmd.exe"
alias powershell="powershell.exe" 
alias wsl="wsl.exe"

# batman configs
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

# Git alias
alias gitprune="git gc --prune=now"


# vim keybindings for zsh
bindkey -v


# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/codereaper/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/codereaper/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/codereaper/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/codereaper/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# pnpm
export PNPM_HOME="/home/codereaper/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Starship config
eval "$(starship init zsh)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


