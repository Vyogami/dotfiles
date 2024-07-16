ZSH_DISABLE_COMPFIX=true

# Plugins
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



# Pokemon
pokemon-colorscripts -r --no-title

# Zsh zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Zsh zsh-syntax-highlighting
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


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
alias lsa='eza -F --icons -a -1'
alias lfl='eza -F --icons -a -F -l'
alias ldl='eza -F --icons -a -d -l'
alias ltl='eza -F --icons -a -T -l'
alias lrl='eza -F --icons -a -T -l'

alias lh='eza -F --icons -h'


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
export MANROFFOPT="-c"

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


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/home/vyogami/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/home/vyogami/miniconda3/etc/profile.d/conda.sh" ]; then
#         . "/home/vyogami/miniconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/home/vyogami/miniconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<
#
# conda deactivate

# Pacman
alias ua-drop-caches='sudo paccache -rk3; yay -Sc --aur --noconfirm'
alias ua-update-all='export TMPFILE="$(mktemp)"; \
    sudo true; \
    rate-mirrors --save=$TMPFILE arch --max-delay=21600 \
      && sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup \
      && sudo mv $TMPFILE /etc/pacman.d/mirrorlist \
      && ua-drop-caches \
      && yay -Syy --noconfirm'

# Atuin config
# eval "$(atuin init zsh)"
#compdef mise
local curcontext="$curcontext"


# mise configurations 
eval "$(mise activate zsh)"

# Yazi file manager configurations
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Bind alt+l to clear screen
bindkey '\el' clear-screen

# Set home and end key as zsh doesn't handle them by default
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# Set default editor to nvim
export EDITOR=nvim
