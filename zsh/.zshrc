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


# eza ls configurations
alias l='eza --icons'
# alias l='eza -ons'
alias ls='eza --icons'
alias la='eza --icons -a'
alias lf='eza --icons -a -F'
alias ld='eza --icons -a -d'
alias lt='eza --icons -a -T'
alias lr='eza --icons -a -r'

alias ll='eza --icons -1'
alias lla='eza --icons -a -1'
alias lfl='eza --icons -a -F -l'
alias ldl='eza --icons -a -d -l'
alias ltl='eza --icons -a -T -l'
alias lrl='eza --icons -a -T -l'

alias lh='eza --icons -h'


# yay config
alias search="yay -Slq | fzf -m --preview 'cat <(yay -Si {1}) <(yay -Fl {1} | \"{print \$2}\")' | xargs -ro yay -S" 

# sudo edit with preserving user envs
alias sudouser="sudo -E -s"

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

# vim alias
alias vi="nvim"

# vim keybindings for zsh
bindkey -v

# set blinking bar as cursor style
echo '\e[5 q'

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm


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



source /home/vyogami/.config/broot/launcher/bash/br

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/vyogami/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/vyogami/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/vyogami/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/vyogami/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

conda deactivate

# Pacman
alias ua-drop-caches='sudo paccache -rk3; yay -Sc --aur --noconfirm'
alias ua-update-all='export TMPFILE="$(mktemp)"; \
    sudo true; \
    rate-mirrors --save=$TMPFILE arch --max-delay=21600 \
      && sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup \
      && sudo mv $TMPFILE /etc/pacman.d/mirrorlist \
      && ua-drop-caches \
      && yay -Syy --noconfirm'
# kw
export fpath=(/home/vyogami/.local/lib/kw $fpath)
autoload compinit && compinit -i
PATH=/home/vyogami/.local/bin:$PATH # kw

# Atuin config
# eval "$(atuin init zsh)"
#compdef mise
local curcontext="$curcontext"


# mise configurations 
eval "$(mise activate zsh)"
