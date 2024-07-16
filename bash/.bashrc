# vi mode
if [[ $- == *i* ]]; then # in interactive session
  bind 'set editing-mode vi'
fi


# set blinking bar as cursor style
echo -ne "\e[5 q"

# yay config
alias search="yay -Slq | fzf -m --preview 'cat <(yay -Si {1}) <(yay -Fl {1} | \"{print \$2}\")' | xargs -ro yay -S" 


# Custom aliases
alias cls='clear'
alias c='clear'
alias mk='mkdir'

# vim alias
alias vi="nvim"

# For zoxide
eval "$(zoxide init bash --cmd cd)"


# windows application aliases
alias files="explorer.exe ."
alias winget="winget.exe"
alias choco="choco.exe"
alias cmd="cmd.exe"
alias powershell="powershell.exe" 
alias wsl="wsl.exe"


# Git alias
alias gitprune="git gc --prune=now"

# sudo edit with preserving user envs
alias sudouser="sudo -E -s"

# Clipboard alias
alias clipboard="xclip -sel clip"

# eza ls configurations
alias l='eza -F --icons'
# alias l='eza -F -ons'
alias ls='eza -F --icons'
alias la='eza -F --icons -a'
alias lf='eza -F --icons -a -F'
alias ld='eza -F --icons -a -d'
alias lt='eza -F --icons -a -T'
alias lr='eza -F --icons -a -r'

alias ll='eza -F --icons -1'
alias lla='eza -F --icons -a -1'
alias lfl='eza -F --icons -a -F -l'
alias ldl='eza -F --icons -a -d -l'
alias ltl='eza -F --icons -a -T -l'
alias lrl='eza -F --icons -a -T -l'

alias lh='eza -F --icons -h'



[[ ${BLE_VERSION-} ]] && ble-attach


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('~/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "~/miniconda3/etc/profile.d/conda.sh" ]; then
#         . "~/miniconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="~/miniconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<

# Pokemon
pokemon-colorscripts -r --no-title

# Starship config
eval "$(starship init bash)"


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


source /home/vyogami/.config/broot/launcher/bash/br
. "$HOME/.cargo/env"

# Pacman

alias ua-drop-caches='sudo paccache -rk3; yay -Sc --aur --noconfirm'
alias ua-update-all='export TMPFILE="$(mktemp)"; \
    sudo true; \
    rate-mirrors --save=$TMPFILE arch --max-delay=21600 \
      && sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup \
      && sudo mv $TMPFILE /etc/pacman.d/mirrorlist \
      && ua-drop-caches \
      && yay -Syy --noconfirm'

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh

# atuin configurations
# eval "$(atuin init bash)"

# mise configurations
eval "$(mise activate bash)"

# Bind alt+l to clear screen
bind '"\el":clear'

# Set default editor to nvim
export EDITOR=nvim
