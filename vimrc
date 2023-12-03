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
                    \ 'whitelist': ['go'],
                    \ 'completor': function('asyncomplete#sources#omni#completor')
                    \  }))
endfunction

au VimEnter * :call Omni()

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
			\
"=====================================================
"==================== FUZZY FIND SYMBOLS =============


" GovimFZFSymbol is a user-defined function that can be called to start fzf in
" a mode whereby it uses govim's new child-parent capabilities to query the
" parent govim instance for gopls Symbol method results that then are used to
" drive fzf.
function GovimFZFSymbol(queryAddition)
  let l:expect_keys = join(keys(s:symbolActions), ',')
  let l:source = join(GOVIMParentCommand(), " ").' gopls Symbol -quickfix'
  let l:reload = l:source." {q}"
  call fzf#run(fzf#wrap({
        \ 'source': l:source,
        \ 'sink*': function('s:handleSymbol'),
        \ 'options': [
        \       '--with-nth', '2..',
        \       '--expect='.l:expect_keys,
        \       '--phony',
        \       '--bind', 'change:reload:'.l:reload
        \ ]}))
endfunction

" Map \s to start a symbol search
"
" Once you have found the symbol you want:
"
" * Enter will open that result in the current window
" * Ctrl-s will open that result in a split
" * Ctrl-v will open that result in a vertical split
" * Ctrl-t will open that result in a new tab
"
nmap <Leader>s :call GovimFZFSymbol('')<CR>

" s:symbolActions are the actions that, in addition to plain <Enter>,
" we want to be able to fire from fzf. Here we map them to the corresponding
" command in VimScript.
let s:symbolActions = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit',
  \ }

" With thanks and reference to github.com/junegunn/fzf.vim/issues/948 which
" inspired the following
function! s:handleSymbol(sym) abort
  " a:sym is a [2]string array where the first element is the
  " key pressed (or empty if simply Enter), and the second element
  " is the entry selected in fzf, i.e. the match.
  "
  " The match will be of the form:
  "
  "   $filename:$line:$col: $match
  "
  if len(a:sym) == 0
    return
  endif
  let l:cmd = get(s:symbolActions, a:sym[0], "")
  let l:match = a:sym[1]
  let l:parts = split(l:match, ":")
  execute 'silent' l:cmd
  execute 'buffer' bufnr(l:parts[0], 1)
  set buflisted
  call cursor(l:parts[1], l:parts[2])
  normal! zz
endfunction

" This comes from govim minimal conf
set updatetime=500
set balloondelay=250
set signcolumn=yes
autocmd! BufEnter,BufNewFile *.go,go.mod syntax on
autocmd! BufLeave *.go,go.mod syntax off
set backspace=2
if has("patch-8.1.1904")
  set completeopt+=popup
  set completepopup=align:menu,border:off,highlight:Pmenu
endif
