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
alias lfl='exa --icons -a -F -l'
alias lla='exa --icons -a -1'
alias ldl='exa --icons -a -d -l'
alias ltl='exa --icons -a -T -l'
alias lrl='exa --icons -a -T -l'

alias lh='exa --icons -h'
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
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

# Git alias

alias gitprune="git gc --prune=now"

# Starship config
starship init fish | source

# Pokemon
pokemon-colorscripts -r --no-title


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f ~/miniconda3/bin/conda
    eval ~/miniconda3/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<

