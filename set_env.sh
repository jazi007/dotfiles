#!/bin/bash

DOTFILESDIR=$(readlink -f $(dirname $BASH_SOURCE))

# check if HOME exist
if [[ -z "$HOME" ]]; then
    echo -e "ERROR: HOME env variable not set"
    return
fi

function do_install() {
    echo -n "$1 [y/N]: "
    read p
    if [[ "$p" == "N" ]]; then
        return 0
    else
        return 1
    fi
}

# tmux
do_install "Setup TMUX"
if [[ $? -ne 0 ]]; then
    printf "\tsetup of TMUX on-going ...\n"
    rm -rf $HOME/.tmux $HOME/.tmux.conf
    mkdir $HOME/.tmux
    wget -O $HOME/.tmux/iceberg.tmux.conf https://raw.githubusercontent.com/gkeep/iceberg-dark/master/.tmux/iceberg.tmux.conf
    ln -s $DOTFILESDIR/tmux.conf $HOME/.tmux.conf
    printf "\tsetup of TMUX done\n"
fi


# create symlinks
setup_nvim=true
if [[ ! -x "$(command -v nvim)" ]]; then
    setup_nvim=false
    do_install "Install neovim"
    if [[ $? -ne 0 ]]; then
        cd $HOME
        mkdir -p $HOME/.local/bin
        cd $HOME/.local/bin
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x nvim.appimage
        ./nvim.appimage --appimage-extract
        ln -s $PWD/squashfs-root/AppRun $HOME/.local/bin/nvim
        setup_nvim=true
    fi
fi
if $setup_nvim; then
    do_install "Setup neovim"
    if [[ $? -ne 0 ]]; then
        printf "\tsetup of neovim on-going ...\n"
        rm -rf $HOME/.config/nvim
        ln -s $DOTFILESDIR/nvim $HOME/.config/
        printf "\tsetup of neovim done\n"
    fi
else
    echo -e '/!\ nvim not installed, skipping neovim config /!\'
fi

# setup bash aliases and gitconfig
if [[ -x "$(command -v python)" ]]; then
    do_install "Setup gitconfig and bash_aliases"
    if [[ $? -ne 0 ]]; then
        printf "\tsetup of git/bash on-going ...\n"
        rm -rf $HOME/.gitconfig $HOME/.bash_aliases
        python $DOTFILESDIR/setup_env.py
        printf "\tsetup of git/bash done\n"
    fi
else
    echo -e '/!\ python not found cannot setup gitconfig and bash_aliases /!\'
fi


# some install for lsp
# sudo apt-get install nodejs npm
# sudo apt-get install clangd-9
# sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-9 100
