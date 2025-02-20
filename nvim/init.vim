" I want this to use my vimrc and existing vim config
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
" When possible use a virtual python that has all the package, this is in its
" way out.
let g:python3_host_prog = '~/.vim/venv/bin/python'
" Load vimrc
source ~/.vimrc
" NeoVide
source ~/.config/nvim/neovide.lua
" Load theme with some config
source ~/.config/nvim/theme.lua
" Load LSP config, so far it has:
"  * Python: ruff
source ~/.config/nvim/lsp.lua
" Load Telescope with some configuration
source ~/.config/nvim/telescope.lua
" airline replacement?
source ~/.config/nvim/lualine.lua
" buffer bar
source ~/.config/nvim/barbar.lua
" auto session
source ~/.config/nvim/autosession.lua


