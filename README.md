# Configuration files

## Bootstrap a system to work in a linux 

* `bootstrap.sh`: idempotent-ish script to get a working and configured vim in a debian based linux
* `dependencies.debian.sh`: some required dependencies, far from complete, it is missing what I know my systems will already have installed.

## Various config files
*All these will be symlinked to their appropriate location in the system*

* `gitconfig`: Configuration for git, this is how I expect git to behave everywhere
* `tmux.conf`: Configuration for tmux, mostly to work well with vi.
* `vimrc`: Base vimrc

### FileType Plugins

* `ftplugin/`
	* `go.vim`: Configuration for [govim](https://github.com/govim/govim) plugin for go.
 	* `python.vim`: Configuration for python, borrowed from [fisadev](https://vim.fisadev.com/)


