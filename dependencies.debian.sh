#!/bin/sh

sudo apt install build-essential curl python3-pip exuberant-ctags ack-grep
# Install whatever latest version of nvim available
wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz 
sudo dpkg -i nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz

# install lua language server, if you do nvim you will do a lot of lua likely just for this.
# TODO: Make a generic download not versino dependent
LUA_SRV_VER=3.13.6
if [ ! -d "~/.local/share/lua-lang-server" ]; then
  mkdir -p ~/.local/share/lua-lang-server;
  wget https://github.com/LuaLS/lua-language-server/releases/download/${LUA_SRV_VER}/lua-language-server-${LUA_SRV_VER}-linux-x64.tar.gz
  tar --extract --file lua-language-server-${LUA_SRV_VER}-linux-x64.tar.gz -av -C ~/.local/share/lua-lang-server
  ln -s ~/.local/share/lua-lang-server/bin/lua-language-server ~/.local/bin/lua-language-server
  rm lua-language-server-${LUA_SRV_VER}-linux-x64.tar.gz 
fi

RG_VER=14.1.0
if [ ! command -v "rg" ]; then
  curl -LO https://github.com/BurntSushi/ripgrep/releases/download/${RG_VER}/ripgrep_${RG_VER}-1_amd64.deb
  sudo dpkg -i ripgrep_${RG_VER}-1_amd64.deb
fi


if [ ! -d "$HOME/.vim/venv" ]; then
  mkdir -p ~/.vim
  python3 -m pip venv ~/.vim/venv
fi

# This is a venv because debian/ubuntu will not allow sudo pip install
~/.vim/venv/bin/python -m pip install pynvim flake8 pylint isort jedi
