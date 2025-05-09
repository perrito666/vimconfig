" Much of this stolen from fisa vim config https://github.com/fisadev/fisa-vim-config
" 
" -------------------
" Initial Settings
" -------------------
"
" To use the background color of your terminal app, change this setting from 0
" to 1
let transparent_background = 0

let using_neovim = has('nvim')

let config_dir = has('nvim') ? stdpath('config') : expand('~/.vim')
let data_dir = has('nvim') ? stdpath('data') .. '/site' : expand('~/.vim')

" Figure out the system Python for Neovim.
" This is a deviation from the original version in fisa's vim
" config. 
" We just get the nearest python3 and ill install dependencies in every venv.
" for now. it is worth noting that in most modern installs of python, it is
" not allowed to install packages outside of the distro/OS package manager and
" some of these are not packaged for all OS so we use A virtualenv, whichever
" is at hand.
if exists("$VIRTUAL_ENV")
    let g:python3_host_prog=substitute(system("which -a python3 | head -n1 | tail -n1"), "\n", '', 'g')
else
    let g:python3_host_prog = '~/.vim/venv/bin/python'
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
Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}
" navigation tree
Plug 'scrooloose/nerdtree'
" Fuzzy find
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" lsp required for python, go, lua lsp
Plug 'rcarriga/nvim-notify'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
" telescope is a nice popup dialog for various things
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'nvim-telescope/telescope-live-grep-args.nvim'
" Lualine is a modern airline/tmuxline/etc
Plug 'nvim-lualine/lualine.nvim'
" If you want to have icons in your statusline choose one of these
Plug 'nvim-tree/nvim-web-devicons' " OPTIONAL: for file icons
" better tabs (notice nvim-web-devicons is a requirement of this and the
" previous plug)
Plug 'lewis6991/gitsigns.nvim' " OPTIONAL: for git status
Plug 'romgrk/barbar.nvim' 
" sessions
Plug 'rmagatti/auto-session'

" python deps from fisadev's vimrc
" Python autocompletion
if vim_plug_just_installed
    Plug 'Shougo/deoplete.nvim', {'do': ':autocmd VimEnter * UpdateRemotePlugins'}
else
    Plug 'Shougo/deoplete.nvim'
endif
" dependencies of deoplete
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
" use jedi with deoplete
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
Plug 'tpope/vim-rhubarb' " fugitive plugin to gbrowse to github
Plug 'ruifm/gitlinker.nvim' " allows copying links to github, also depends on plenary
" Git/mercurial/others diff icons on the side of the file lines
Plug 'mhinz/vim-signify'
" Yank history navigation
Plug 'vim-scripts/YankRing.vim'
" Linters
Plug 'neomake/neomake'
" Nice icons in the file explorer and file type status line.
Plug 'ryanoasis/vim-devicons'
" tags because python
Plug 'majutsushi/tagbar'


" some themes
Plug 'ribru17/bamboo.nvim'


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
set number

set ttyfast

" Set default encoding to utf-8 as one should
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

" -----------------------------
" Deoplete 
" -----------------------------
" Use deoplete.
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option({
\   'ignore_case': v:true,
\   'smart_case': v:true,
\})
" turn off deoplete on Telescope, it is incredibly annoying
autocmd FileType TelescopePrompt call deoplete#custom#buffer_option('auto_complete', v:false)
" complete with words from any opened file
let g:context_filetype#same_filetypes = {}
let g:context_filetype#same_filetypes._ = '_'

" -----------------------------
" Jedi-vim 
" -----------------------------

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


" -----------------------------
" Yankring 
" -----------------------------

if has('nvim-0.8')
    let g:yankring_history_dir = stdpath('state')
else
    let g:yankring_history_dir = data_dir
endif
" Fix for yankring and neovim problem when system has non-text things
" copied in clipboard
let g:yankring_clipboard_monitor = 0

" Some sensible default for known types
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

  autocmd FileType json set formatprg=jq
augroup END


" -----------------------------
" Remember edit position
" -----------------------------
" Remember position of last edit and return on reopen
" Let me be honest, i do not entirely understand what this incantation does
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" -----------------------------
"  Tabs
" -----------------------------

" always show the tabline, I love consistency and hate my screen real state :p
set showtabline=2
" I would rather use a fancier combo but pgup/down or ctr/cmd ][ are usually
" captured by the terminal emulator for the same purpose
nmap tn <Esc>:tabnext<CR>
nmap tp <Esc>:tabprevious<CR>
" tab navigation mappings, not working mostly bc M is captured
map tt :tabnew 
map <M-Right> :tabn<CR>
imap <M-Right> <ESC>:tabn<CR>
map <M-Left> :tabp<CR>
imap <M-Left> <ESC>:tabp<CR>


" -----------------------------
" NERDTree
" -----------------------------

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

" -----------------------------
" Tag
" -----------------------------
map <F4> :TagbarToggle<CR>
let g:tagbar_autofocus = 1
let g:tagbar_foldlevel = 1

" "run ctags on current folder
command! MakeTags !ctags -R --exclude=.venv --exclude=.mypy* --exclude=.pip* --exclude=*.pyc --exclude=*.orig .
command! LibTags !find `".venv/bin/python" -c "import distutils; print(distutils.sysconfig.get_python_lib())"` -name \*.py | ctags -L- --append


" -----------------------------
" Grep
" -----------------------------
" "Use ack as grep program
" "I should be using a config file for all folder to avoid
set grepprg=ack\ --ignore-dir=.venv\ --ignore-dir=.mypy_cache\ --ignore-dir=.mypy-venv-public-api\ --ignore-dir=.mypy-venv\ --ignore-dir=.mypy-venv-devtools\ --ignore-file=is:tags\ --ignore-file=ext:orig\ --ignore-file=ext:pyc\ --nocolor\ --nogroup\ --column
" "Format of ack result so it is correctly displyes on quickfix window
set grepformat=%f:%l:%c:%m

augroup myvimrc
	autocmd!
	autocmd QuickFixCmdPost [^l]* cwindow 20
	autocmd QuickFixCmdPost l*    lwindow 20
augroup END

" "search word under curson with ack, redraw code window
map <leader>ffg :execute "silent grep! " . expand("<cword>") . " . " <CR><C-W><Up><C-L><C-W><Down>


" buffers selection screen
map <leader>b :Buffers<CR>

