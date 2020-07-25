#!/bin/bash
#
# Below installs Nim from source to ensure the latest version is used.
# Set the version of the Nim source code file to download below -
# check Nim download age here:  https://nim-lang.org/install_unix.html
#
# Script is also used with GitHib actions for building and testing Nim
# applications.
# 
NIMVER=nim-1.2.0
#
if [ ! -f $HOME/.nimble/bin/nim ]; then
    # ensure Ubuntu base dev C compiler is installed and OpenSSL dependency:
    printf "\nInstalling: build-essential and openssl to build Nim"
    sudo apt -y install build-essential openssl
    # now start Nim install process...
    printf "\nAdding Nim 'stable' version '%s' from: 'https://nim-lang.org/download/' ...\n\n" "$NIMVER"
    if [ ! -d $HOME/.nimble ]; then
        printf "Creating directory ~/.nimble...\n"
        mkdir $HOME/.nimble
    fi
    # used for Nim build area
    if [ ! -d $HOME/scratch ]; then
        printf "Creating directory ~/scratch...\n"
        mkdir $HOME/scratch
    fi
    cd $HOME/scratch
    # download source code - unless already exists...
    if [ ! -f $NIMVER.tar.xz ]; then
        printf "Downloading Nim version: '%s'...\n" "$NIMVER"
        curl https://nim-lang.org/download/$NIMVER.tar.xz -O
    else
        printf "Existing Nim dowload file found: '%s'\n" "$NIMVER.tar.xz"
    fi
    # if not unarchived yet... do it
    if [ ! -d $NIMVER ] && [ -f $NIMVER.tar.xz ]; then
        tar -xJvf $NIMVER.tar.xz
    fi
    printf "Nim source unpacked... starting build of compiler and tools...\n"
    cd $NIMVER
    ./build.sh
    printf "\n\nMAIN C SOURCE BUILD COMPLETED!!\n\n"
    printf "Now build and installing Nim development environment to: '~/.nimble'\n\n"
    printf "Building (with the nim compiler) the Nim 'koch' tool...\n"
    bin/nim c koch
    printf "Building (with the nim compiler) the Nim 'tools'...\n"
    ./koch tools
    printf "Building (with the nim compiler) the 'nimble' tool...\n"
    ./koch nimble
    printf "Running the official installer script for Nim...\n"
    # install everything into: $HOME/.nimble
    sh ./install.sh $HOME/.nimble
    cp ./bin/* $HOME/.nimble/nim/bin/
    # add addtional tools to support Nim usage
    #printf "Installing supporting tools for Nim...\n"
    #mkdir -p $HOME/.nimble/tools
    #if [ -f ./tools/nim.bash-completion ]; then
    #    cp ./tools/nim.bash-completion $HOME/.nimble/tools
    #fi
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
    #
    printf "\nDONE\n"
else
    printf "\n'Nim compiler' is already installed... skipping install\n"
fi
