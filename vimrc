" Much of this stolen from fisa vim config https://github.com/fisadev/fisa-vim-config
" 
" -------------------
" Initial Settings
" -------------------
"
" To use fancy symbols wherever possible, change this setting from 0 to 1
" and use a font from https://github.com/ryanoasis/nerd-fonts in your terminal
" (if you aren't using one of those fonts, you will see funny characters here.
" Trust me, they look nice when using one of those fonts).
let fancy_symbols_enabled = 0

" To use the background color of your terminal app, change this setting from 0
" to 1
let transparent_background = 0

let using_neovim = has('nvim')
let using_vim = !using_neovim

let config_dir = has('nvim') ? stdpath('config') : expand('~/.vim')
let data_dir = has('nvim') ? stdpath('data') .. '/site' : expand('~/.vim')

" Figure out the system Python for Neovim.
if exists("$VIRTUAL_ENV")
    let g:python3_host_prog=substitute(system("which -a python3 | head -n2 | tail -n1"), "\n", '', 'g')
else
    let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')
endif

" -----------------------
" Vim-plug initialization
" -----------------------
" Avoid modifying this section, unless you are very sure of what you are doing
" In short this bootstraps installing plug, which I used to do by hand
"

let vim_plug_just_installed = 0
let vim_plug_path = data_dir .. '/autoload/plug.vim'
if !filereadable(vim_plug_path)
    echo "Installing Vim-plug..."
    echo ""
    silent execute "!curl -fLo " .. vim_plug_path .. " --create-dirs "
      \ .. "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    let vim_plug_just_installed = 1
endif

" manually load vim-plug the first time
if vim_plug_just_installed
    :execute 'source '.fnameescape(vim_plug_path)
endif


call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'


" Make sure you use single quotes
" let Vundle manage Vundle, required
Plug 'VundleVim/Vundle.vim'
" Plug 'govim/govim'
Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}
Plug 'edkolev/tmuxline.vim'
Plug 'vim-airline/vim-airline'
Plug 'gruvbox-community/gruvbox'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
" autocomplete as recommended by govim
" Plug 'prabirshrestha/asyncomplete.vim'
" Plug 'yami-beta/asyncomplete-omni.vim'
" lsp required for python lsp
Plug 'prabirshrestha/vim-lsp'
" python deps from fisadev's vimrc
" Python autocompletion
if using_neovim && vim_plug_just_installed
    Plug 'Shougo/deoplete.nvim', {'do': ':autocmd VimEnter * UpdateRemotePlugins'}
else
    Plug 'Shougo/deoplete.nvim'
endif
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'deoplete-plugins/deoplete-jedi'
" Completion from other opened files
Plug 'Shougo/context_filetype.vim'
" Just to add the python go-to-definition and similar features, autocompletion
" from this plugin is disabled
Plug 'davidhalter/jedi-vim'
" Automatically sort python imports
Plug 'fisadev/vim-isort'

" General from fisadev's vimrc
" Git integration
Plug 'tpope/vim-fugitive'
" Git/mercurial/others diff icons on the side of the file lines
Plug 'mhinz/vim-signify'
" Yank history navigation
Plug 'vim-scripts/YankRing.vim'
" Linters
Plug 'neomake/neomake'
" Nice icons in the file explorer and file type status line.
Plug 'ryanoasis/vim-devicons'





if using_vim
    " Consoles as buffers (neovim has its own consoles as buffers)
    Plug 'rosenfeld/conque-term'
    " XML/HTML tags navigation (neovim has its own)
    Plug 'vim-scripts/matchit.zip'
endif


" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()

" ---------------------
" Install plugins the first time vim runs
" ---------------------

if vim_plug_just_installed
    echo "Installing Bundles, please ignore key map error messages"
    :PlugInstall
endif


" I borrowed some things from Fatih Arslan github.com/fatih/dotfiles
filetype plugin indent on

set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

set ttyfast

set ttymouse=xterm2
set ttyscroll=3

" enable mouse
" set mouse=a 
" Set default encoding to utf-8
set encoding=utf-8
set autoread
set autoindent
set smartindent
" Makes backspace key more powerful.
set backspace=indent,eol,start  
" Show me what I'm typing
set showcmd                  
" Split vertical windows right to the current windows
set splitright               
" Split horizontal windows below to the current windows
set splitbelow               
" We show the mode with airline or lightline
set noshowmode               
" Search case insensitive...
set ignorecase               
" ... but not it begins with upper case
set smartcase                
set completeopt=menu,menuone
" speed up syntax highlighting
set nocursorcolumn           
set nocursorline
" Shut off completion messages
set shortmess+=c   
" If Vim beeps during completion
set belloff+=ctrlg 

set lazyredraw
" increase max memory to show syntax highlighting for large files 
set maxmempattern=20000
if has('persistent_undo')
  set undofile
  set undodir=~/.cache/vim
endif

if using_vim
    " A bunch of things that are set by default in neovim, but not in vim

    " no vi-compatible
    set nocompatible

    " allow plugins by file type (required for plugins!)
    filetype plugin on
    filetype indent on

    " always show status bar
    set ls=2

    " incremental search
    set incsearch
    " highlighted search results
    set hlsearch

    " syntax highlight on
    syntax on

    " better backup, swap and undos storage for vim (nvim has nice ones by
    " default)
    set directory=~/.vim/dirs/tmp     " directory to place swap files in
    set backup                        " make backup files
    set backupdir=~/.vim/dirs/backups " where to put backup files
    set undofile                      " persistent undos - undo after you re-open the file
    set undodir=~/.vim/dirs/undos
    set viminfo+=n~/.vim/dirs/viminfo
    " create needed directories if they don't exist
    if !isdirectory(&backupdir)
        call mkdir(&backupdir, "p")
    endif
    if !isdirectory(&directory)
        call mkdir(&directory, "p")
    endif
    if !isdirectory(&undodir)
        call mkdir(&undodir, "p")
    endif
end

set fillchars+=vert:\ 

if transparent_background
    highlight Normal guibg=none
    highlight Normal ctermbg=none
    highlight NonText ctermbg=none
endif

" needed so deoplete can auto select the first suggestion
set completeopt+=noinsert
" comment this line to enable autocompletion preview window
" (displays documentation related to the selected completion option)
" disabled by default because preview makes the window flicker
set completeopt-=preview

" autocompletion of files and commands behaves like shell
" (complete only the common part, list the options that match)
set wildmode=list:longest

" save as sudo
ca w!! w !sudo tee "%"

" when scrolling, keep cursor 3 lines away from screen border
set scrolloff=3

" fix problems with uncommon shells (fish, xonsh) and plugins running commands
" (neomake, ...)
set shell=/bin/bash

" Deoplete -----------------------------

" Use deoplete.
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option({
\   'ignore_case': v:true,
\   'smart_case': v:true,
\})
" complete with words from any opened file
let g:context_filetype#same_filetypes = {}
let g:context_filetype#same_filetypes._ = '_'

" Jedi-vim ------------------------------

" Disable autocompletion (using deoplete instead)
let g:jedi#completions_enabled = 0

" All these mappings work only for python code:
" Go to definition
let g:jedi#goto_command = ',d'
" Find ocurrences
let g:jedi#usages_command = ',o'
" Find assignments
let g:jedi#goto_assignments_command = ',a'
" Go to definition in new tab
nmap ,D :tab split<CR>:call jedi#goto()<CR>


" Yankring -------------------------------

if using_neovim
    if has('nvim-0.8')
        let g:yankring_history_dir = stdpath('state')
    else
        let g:yankring_history_dir = data_dir
    endif
    " Fix for yankring and neovim problem when system has non-text things
    " copied in clipboard
    let g:yankring_clipboard_monitor = 0
else
    let g:yankring_history_dir = '~/.vim/dirs/'
endif


augroup filetypedetect
  command! -nargs=* -complete=help Help vertical belowright help <args>
  autocmd FileType help wincmd L
  
  autocmd BufNewFile,BufRead .tmux.conf*,tmux.conf* setf tmux
  autocmd BufNewFile,BufRead .nginx.conf*,nginx.conf* setf nginx
  autocmd BufNewFile,BufRead *.hcl setf conf

  autocmd BufRead,BufNewFile *.gotmpl set filetype=gotexttmpl
  
  autocmd BufNewFile,BufRead *.ino setlocal noet ts=4 sw=4 sts=4
  autocmd BufNewFile,BufRead *.txt setlocal noet ts=4 sw=4
  autocmd BufNewFile,BufRead *.md setlocal noet ts=4 sw=4
  autocmd BufNewFile,BufRead *.html setlocal noet ts=4 sw=4
  autocmd BufNewFile,BufRead *.vim setlocal expandtab shiftwidth=2 tabstop=2
  autocmd BufNewFile,BufRead *.hcl setlocal expandtab shiftwidth=2 tabstop=2
  autocmd BufNewFile,BufRead *.sh setlocal expandtab shiftwidth=2 tabstop=2
  autocmd BufNewFile,BufRead *.proto setlocal expandtab shiftwidth=2 tabstop=2
  autocmd BufNewFile,BufRead *.fish setlocal expandtab shiftwidth=2 tabstop=2
  
  autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
  autocmd FileType yaml setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType json setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2
augroup END

"=====================================================
"===================== STATUSLINE ====================

if fancy_symbols_enabled
    let g:tmuxline_preset = {
          \'a'    : '#S',
          \'win'  : '#I #W',
          \'cwin' : '#I #W',
          \'x'    : '%a',
          \'y'    : '%Y-%m-%d %H:%M',
          \'z'    : ' #h',
          \'options' : {'status-justify' : 'left', 'status-position' : 'top'}}

    let g:tmuxline_powerline_separators = 0
endif

"=====================================================
"==================== THEME ==========================

" Assume background is dark, this is true for 99% of my terminals
" Otherwise color scheme is really hard to see
set background=dark
" Change the color scheme to one that i like (this is as personal as it gets)
colorscheme gruvbox
" Show line numbers, I have no clue why this is not a default
set number
" Remember position of last edit and return on reopen
" Let me be honest, i do not entirely understand what this incantation does
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"=====================================================
"==================== TABS ===========================

" always show the tabline, I love consistency and hate my screen real state :p
set showtabline=2
" I would rather use a fancier combo but pgup/down or ctr/cmd ][ are usually
" captured by the terminal emulator for the same purpose
nmap tn <Esc>:tabnext<CR>
nmap tp <Esc>:tabprevious<CR>
" tab navigation mappings
map tt :tabnew 
map <M-Right> :tabn<CR>
imap <M-Right> <ESC>:tabn<CR>
map <M-Left> :tabp<CR>
imap <M-Left> <ESC>:tabp<CR>

"=====================================================
"==================== GOVIM ==========================

set signcolumn=number

"=====================================================
"==================== AUTOCOMPLETE ===================

" function! Omni()
"     call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
"                     \ 'name': 'omni',
"                     \ 'whitelist': ['go', 'python'],
"                     \ 'completor': function('asyncomplete#sources#omni#completor')
"                     \  }))
" endfunction
" 
" au VimEnter * :call Omni()
" 
" inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"


"=====================================================
"==================== NERDTree =======================


" toggle nerdtree display
map <F3> :NERDTreeToggle<CR>
" open nerdtree with the current file selected
nmap ,t :NERDTreeFind<CR>
" don;t show these file types
let NERDTreeIgnore = ['\.pyc$', '\.pyo$']

" Enable folder icons
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1

" Fix directory colors
highlight! link NERDTreeFlags NERDTreeDir
