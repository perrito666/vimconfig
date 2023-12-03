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

"=====================================================
"==================== FUZZY FIND SYMBOLS =============

" GovimFZFSymbol is a user-defined function that can be called to start fzf in
" a mode whereby it uses govim's new child-parent capabilities to query the
" parent govim instance for gopls Symbol method results that then are used to
" drive fzf.
if !exists("*GovimFZFSymbol")
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
endif

" Map \s to start a symbol search
"
" Once you have found the symbol you want:
"
" * Enter will open that result in the current window
" * Ctrl-s will open that result in a split
" * Ctrl-v will open that result in a vertical split
" * Ctrl-t will open that result in a new tab
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
if !exists("*s:handleSymbol")
  function s:handleSymbol(sym) abort
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
endif

nmap <silent> <buffer> <Leader>h : <C-u>call GOVIMHover()<CR>
