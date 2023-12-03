#!/bin/bash
# set -ex

## MIT License
#
## Copyright (c) [year] [fullname]
#
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to deal
## in the Software without restriction, including without limitation the rights
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
## copies of the Software, and to permit persons to whom the Software is
## furnished to do so, subject to the following conditions:
#
## The above copyright notice and this permission notice shall be included in all
## copies or substantial portions of the Software.
#
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
## SOFTWARE.

# Check if ~/.vim folder exists, create it if not
if [ ! -d "$HOME/.vim" ]; then
    mkdir -p "$HOME/.vim"
fi

if [ ! -d "$HOME/.vim/autoload/plug.vim" ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Clone or update vimconfig repository
if [ ! -d "$HOME/vimconfig" ]; then
    git clone https://github.com/perrito666/vimconfig.git "$HOME/vimconfig"
else
    cd "$HOME/vimconfig"
    git pull origin main
fi

# Check if ~/.vimrc is already a symbolic link to the repository file
if [ ! -L "$HOME/.vimrc" ] || [ "$(readlink "$HOME/.vimrc")" != "$HOME/vimconfig/vimrc" ]; then
    # Backup existing ~/.vimrc if it is not a link or links to a different file
    if [ -f "$HOME/.vimrc" ]; then
        mv "$HOME/.vimrc" "$HOME/.vimrc.bak"
    fi

    # Link vimrc from vimconfig to ~/.vimrc
    ln -s "$HOME/vimconfig/vimrc" "$HOME/.vimrc"
fi

# Check if ~/.tmux.conf is already a symbolic link to the repository file
if [ ! -L "$HOME/.tmux.conf" ] || [ "$(readlink "$HOME/.tmux.conf")" != "$HOME/vimconfig/tmux.conf" ]; then
    # Backup existing ~/.tmux.conf if it is not a link or links to a different file
    if [ -f "$HOME/.tmux.conf" ]; then
        mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak"
    fi

    # Link tmux.conf from vimconfig to ~/.tmux.conf
    ln -s "$HOME/vimconfig/tmux.conf" "$HOME/.tmux.conf"
fi

# Check if ~/.gitconfig is already a symbolic link to the repository file
if [ ! -L "$HOME/.gitconfig" ] || [ "$(readlink "$HOME/.gitconfig")" != "$HOME/vimconfig/gitconfig" ]; then
    # Backup existing ~/.gitconfig if it is not a link or links to a different file
    if [ -f "$HOME/.gitconfig" ]; then
        mv "$HOME/.gitconfig" "$HOME/.gitconfig.bak"
    fi

    # Link gitconfig from vimconfig to ~/.gitconfig
    ln -s "$HOME/vimconfig/gitconfig" "$HOME/.gitconfig"
fi


# now link the ftplugins if they do not exist
vimconfig_dir="$HOME/vimconfig"
ftplugin_dir="$vimconfig_dir/ftplugin"
target_dir="$HOME/.vim/after/ftplugin"

# Ensure target directory exists
mkdir -p "$target_dir"

# Iterate through files in ftplugin_dir and create symbolic links
for file in "$ftplugin_dir"/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        target_path="$target_dir/$filename"

        # Create symbolic link if it doesn't exist
        if [ ! -e "$target_path" ]; then
            ln -s "$file" "$target_path"
            echo "Linked $filename to $target_path"
        fi
    fi
done

# I need nerdfonts, Hack is not a strong preference only a convenient choice
if [ ! -d "$HOME/vimconfig/fonts" ]; then
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.tar.xz
  mkdir $HOME/vimconfig/fonts
  tar -xJf Hack.tar.xz -C $HOME/vimconfig/fonts
fi

echo "Setup completed successfully!"

