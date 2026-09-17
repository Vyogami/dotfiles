#!/bin/sh

# keyd is a Linux-only kernel input daemon; skip its installer on other OSes
# (e.g. macOS) so `dotter deploy` does not try to build/sudo-install it there.
if [ "$(uname)" = "Linux" ]; then
    source keyd/keyd-installer.sh
fi
