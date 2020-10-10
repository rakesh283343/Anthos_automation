#!/usr/bin/env bash


export BASE_DIR=$PWD>> /home/gkeadmin/.bashrc
export WORK_DIR=$BASE_DIR/workdir>> /home/gkeadmin/.bashrc
mkdir -p $WORK_DIR/bin >> /home/gkeadmin/.bashrc
export PATH=$PATH:$WORK_DIR/bin:>> /home/gkeadmin/.bashrc

# Install Tree
sudo apt-get install tree

if command -v tree 2>/dev/null; then
        echo "tree already installed."
else
        echo "Installing tree..."
        sudo apt-get install tree
        echo "tree Installation completed."
fi
source /home/gkeadmin/.bashrc
