# Description

A page to save dot files for neovim, git and bash

# Installation

## neovim install

**NVIM>=v0.5.0 rquired**

```bash
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install neovim
python3 -m pip install --user --upgrade pynvim
python2 -m pip install --user --upgrade pynvim
pip3 install neovim-remote
```

## starship install

**starship** is a minimal cross shell prompt for more info [web page](https://starship.rs/)
```bash
sudo apt-get install fonts-powerline
sudo apt install fonts-firacode
curl -fsSL https://starship.rs/install.sh | bash
```

## clone repo and update env

Note: `make sur to save a copy of your local files/dir`

```bash
cd $HOME
git clone https://github.com/jazi007/dotfiles.git
cd dotfiles
./set_env.sh
```
