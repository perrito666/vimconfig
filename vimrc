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
Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}
Plug 'edkolev/tmuxline.vim'
Plug 'vim-airline/vim-airline'
Plug 'gruvbox-community/gruvbox'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
" autocomplete as recommended by govim
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'yami-beta/asyncomplete-omni.vim'
" lsp required for python lsp
Plug 'prabirshrestha/vim-lsp'
" python deps from fisadev's vimrc
" Python autocompletion
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
set smartindent
" Makes backspace key more powerful.
set backspace=indent,eol,start  
" Shows the match while typing
set incsearch                   
" Highlight found searches
set hlsearch                    
" Show me what I'm typing
set showcmd                  
" Don't use swapfile
set noswapfile               
" Don't create annoying backup files
set nobackup                 
set nowritebackup
" Split vertical windows right to the current windows
set splitright               
" Split horizontal windows below to the current windows
set splitbelow               
" Do not show matching brackets by flickering
set noshowmatch              
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

"=====================================================
"==================== GOVIM ==========================

set signcolumn=number

"=====================================================
"==================== AUTOCOMPLETE ===================

function! Omni()
    call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
                    \ 'name': 'omni',
                    \ 'whitelist': ['go', 'python'],
                    \ 'completor': function('asyncomplete#sources#omni#completor')
                    \  }))
endfunction

au VimEnter * :call Omni()

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"


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
