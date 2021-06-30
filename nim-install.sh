#!/bin/bash
#
# Below installs the Nim 'Linux x64 bit' offical binary bundle only!
#
# Script is also used with GitHib actions for building and testing Nim
# applications.
#
# using Nim official binary built archive:
#   https://nim-lang.org/download/nim-1.2.4-linux_x64.tar.xz
#
# change below to match the required Nim download version wanted:
NIMVER=nim-1.4.8
#
if [ ! -f $HOME/.nimble/bin/nim ]; then
    # ensure Ubuntu base dev C compiler is installed and OpenSSL dependency:
    printf "\nInstalling: build-essential and openssl to build Nim"
    sudo apt -y install build-essential openssl git curl
    # now start Nim install process...
    printf "\nAdding Nim 'stable' binary version '%s' from: 'https://nim-lang.org/download/' ...\n\n" "$NIMVER"
    #
    # Add the install location for Nim, Nimble, and tools in:  ~/.nimble
    if [ ! -d $HOME/.nimble ]; then
        printf "Creating Nim install directory '~/.nimble'...\n"
        mkdir $HOME/.nimble
    fi
    # used for Nim unpack and prep area
    if [ ! -d $HOME/scratch ]; then
        printf "Creating directory ~/scratch...\n"
        mkdir $HOME/scratch
    fi
    cd $HOME/scratch
    # download Nim binary build archive - unless already exists...
    if [ ! -f $NIMVER-linux_x64.tar.xz ]; then
        printf "Downloading Nim version: '%s'...\n" "$NIMVER"
        curl -OL https://nim-lang.org/download/$NIMVER-linux_x64.tar.xz
    else
        printf "Existing Nim dowload file found: '%s'\n" "$NIMVER-linux_x64.tar.xz"
    fi
    # if not unarchived yet... do it
    if [ ! -d $NIMVER ] && [ -f $NIMVER-linux_x64.tar.xz ]; then
        tar -xJvf $NIMVER-linux_x64.tar.xz
    fi
    printf "Nim pre-compiled archive unpacked... starting install of compiler and tools...\n"
    cd $NIMVER
    printf "Running the official installer script for Nim...\n"
    # install everything into: $HOME/.nimble
    sh ./install.sh $HOME/.nimble
    cp ./bin/* $HOME/.nimble/nim/bin/
    # add path update if Nim is installed
    if [ -d $HOME/.nimble/nim/bin ]; then
        PATH="${PATH}":$HOME/.nimble/nim/bin:$HOME/.nimble/bin
    fi
    export PATH
    printf "\n\n\nCongratulations - Nim is now installed!!\n\nUpdating nimble package manager...\n\n"
    nimble refresh -y
    nimble install -y nimble
    # if nimble was updated - move the original to a new name to stop conflicts
    if [ -f $HOME/.nimble/nim/bin/nimble ] && [ -f $HOME/.nimble/bin/nimble ]; then
        mv $HOME/.nimble/nim/bin/nimble $HOME/.nimble/nim/bin/nimble-orig
    fi
    # safety flush all cached files to system...
    sync
    #
    printf "\nDONE\n"
else
    printf "\n'Nim compiler' is already installed... skipping install\n"
fi
