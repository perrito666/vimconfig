#!/bin/sh

sudo apt install vim build-essential curl python3-pip exuberant-ctags ack-grep
# This will not work on debian, find a way to make a virtualenv
sudo pip3 install pynvim flake8 pylint isort jedi
