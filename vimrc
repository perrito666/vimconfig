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
Plug 'govim/govim'
Plug 'tmux-plugins/vim-tmux'
Plug 'edkolev/tmuxline.vim'
Plug 'vim-airline/vim-airline'
Plug 'gruvbox-community/gruvbox'
Plug 'scrooloose/nerdtree'

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting

" I borrowed some things from Fatih Arslan github.com/fatih/dotfiles
filetype plugin indent on

set ttyfast

set ttymouse=xterm2
set ttyscroll=3

" enable mouse
set mouse=a 
" Set default encoding to utf-8
set encoding=utf-8
set autoread
set autoindent
" Makes backspace key more powerful.
set backspace=indent,eol,start  
" Shows the match while typing
set incsearch                   
" Highlight found searches
set hlsearch                    
set showcmd                  " Show me what I'm typing
set noswapfile               " Don't use swapfile
set nobackup                 " Don't create annoying backup files
set splitright               " Split vertical windows right to the current windows
set splitbelow               " Split horizontal windows below to the current windows
set noshowmatch              " Do not show matching brackets by flickering
set noshowmode               " We show the mode with airline or lightline
set ignorecase               " Search case insensitive...
set smartcase                " ... but not it begins with upper case
set completeopt=menu,menuone
set nocursorcolumn           " speed up syntax highlighting
set nocursorline
set shortmess+=c   " Shut off completion messages
set belloff+=ctrlg " If Vim beeps during completion

set lazyredraw
" increase max memory to show syntax highlighting for large files 
set maxmempattern=20000
if has('persistent_undo')
  set undofile
  set undodir=~/.cache/vim
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

let g:tmuxline_preset = {
      \'a'    : '#S',
      \'win'  : '#I #W',
      \'cwin' : '#I #W',
      \'x'    : '%a',
      \'y'    : '%Y-%m-%d %H:%M',
      \'z'    : ' #h',
      \'options' : {'status-justify' : 'left', 'status-position' : 'top'}}

let g:tmuxline_powerline_separators = 0


" Assume background is dark, this is true for 99% of my terminals
" Otherwise color scheme is really hard to see
set background=dark
" Show line numbers, I have no clue why this is not a default
set number
" Remember position of last edit and return on reopen
" Let me be honest, i do not entirely understand what this incantation does
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"" Tabs
" always show the tabline, I love consistency and hate my screen real state :p
set showtabline=2
" I would rather use a fancier combo but pgup/down or ctr/cmd ][ are usually
" captured by the terminal emulator for the same purpose
nmap tn <Esc>:tabnext<CR>
nmap tp <Esc>:tabprevious<CR>


