if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Enable vi key bindings
fish_vi_key_bindings 

# Disable fish greeting
set fish_greeting
set fish_cursor_insert line blink
set fish_cursor_replace_one underscore


# ls configurations
#alias l='ls'
#function ls
#   nu -c "ls $argv[1..-1]"
#end

# Run any command in nu shell
function nuc
   nu -c "$argv[1..-1]"
end


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
alias lsa='ls -lah'


# yay config
alias search="yay -Slq | fzf -m --preview 'cat <(yay -Si {1}) <(yay -Fl {1} | \"{print \$2}\")' | xargs -ro yay -S" 

# Clipboard alias
alias clipboard="xclip -sel clip"

# sudo edit with preserving user envs
alias sudouser="sudo -E -s"

# Custom aliases
alias cls='clear'
alias c='clear'
alias r='clear'
alias mk='mkdir'


# For zoxide
zoxide init fish | source
alias cd="z"
alias ..="z .."
alias ...="z ../.."
alias .4="z ../../.."
alias .5="z ../../../.."

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

alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

# Git alias

alias gitprune="git gc --prune=now"

# Starship config
starship init fish | source

# Pokemon
pokemon-colorscripts -r --no-title


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# if test -f ~/miniconda3/bin/conda
#     eval ~/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# end
# <<< conda initialize <<<

# deactivate conda base environment
# conda deactivate

# add cargo binaries to the path
export PATH="$PATH:$HOME/.cargo/bin"

# Pacman 
alias ua-drop-caches='sudo paccache -rk3; yay -Sc --aur --noconfirm'
alias ua-update-all='export TMPFILE="$(mktemp)"; \
    sudo true; \
    rate-mirrors --save=$TMPFILE arch --max-delay=21600 \
      && sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup \
      && sudo mv $TMPFILE /etc/pacman.d/mirrorlist \
      && ua-drop-caches \
      && yay -Syy --noconfirm'

# vim alias
alias vi="nvim"


# Atuin config
# eval "$(atuin init fish)"

# Created by `pipx` on 2024-04-04 23:50:45
set PATH $PATH /home/vyogami/.local/bin

# Mise configuartions
mise activate fish | source

# Yazi configurations
function yy
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

# # Bind alt+l to clear screen

function fish_user_key_bindings
  bind --preset --erase \el
  bind --preset --erase -M insert \el
  bind --preset --erase -M visual \el
  bind --preset -M insert \el 'clear; commandline -f repaint'
  bind --preset -M visual \el 'clear; commandline -f repaint'
  bind --preset \el 'clear; commandline -f repaint'
end

# Set editor to nvim
export EDITOR=nvim
