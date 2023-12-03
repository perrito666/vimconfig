#!/bin/bash

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

# Clone Vundle.vim if not already cloned
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
fi

# Clone or update vimconfig repository
if [ ! -d "$HOME/vimconfig" ]; then
    git clone https://github.com/perrito666/vimconfig.git "$HOME/vimconfig"
else
    cd "$HOME/vimconfig"
    git pull origin master
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

# Link vimrc from vimconfig to ~/.vimrc
ln -s "$HOME/vimconfig/vimrc" "$HOME/.vimrc"

echo "Setup completed successfully!"

