#!/bin/bash

# Create temp directory
mkdir tmp 
cd tmp 

# Cloning the repo
# https://github.com/rvaiya/keyd.git
git clone https://github.com/rvaiya/keyd.git 
cd keyd 

# Building and installing keyd sevice 
make 
sudo make install 
cd .. 
cd ..

# Spawn default.conf in /etc/keyd/
sudo cp ./keyd/default.conf /etc/keyd/default.conf

# start the daemon 
sudo systemctl enable --now keyd 

# To remove the temp folder
rm -rf ./tmp/
