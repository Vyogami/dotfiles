if status is-interactive
    # Commands to run in interactive sessions can go here
end


# Disable fish greeting
set fish_greeting
set fish_cursor_insert line blink
set fish_cursor_replace_one underscore


# Prompt configs
set --global tide_left_prompt_items os pwd git newline character
set --global tide_right_prompt_items status java virtual_env node vi_mode


# ls configurations
alias l='ls'
function ls
   nu -c "ls $argv[1..-1]"
end

# Run any command in nu shell
function nuc
   nu -c "$argv[1..-1]"
end


alias la='ls -a'
alias ld='la -D'
alias lsa='ls -la'
alias lh='ls -h'
alias lf='ls -f'
alias ldl='la -D -l'


# yay config
alias search="yay -Slq | fzf -m --preview 'cat <(yay -Si {1}) <(yay -Fl {1} | \"{print \$2}\")' | xargs -ro yay -S" 


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


