#!/bin/bash

pretty_print() {
  # Define ANSI escape codes for colors
  GREEN='\033[0;32m'
  RESET='\033[0m' # Reset color to default

  # Check if any arguments are provided
  if [ $# -eq 0 ]; then
    echo "Usage: pretty_print <text>"
    return 1
  fi

  # Print the input text with the appropriate color for stdout
  echo -e "${GREEN}$@${RESET}"

}

pretty_print "Deleting old ~/.dotfiles"
rm -rf ~/.dotfiles/

pretty_print "Cloning github.com/vyogami/dotfiles into ~/.dotfiles/"
git clone --recursive https://github.com/vyogami/dotfiles.git ~/.dotfiles/

pretty_print "Installing keyd && deploying configs"
cd ~/.dotfiles/
cp ./.dotter/linux.toml ./.dotter/local.toml
./dotter -f  
