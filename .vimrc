set directory^=$LOCALAPPDATA/vim/swap//
set backupdir^=$LOCALAPPDATA/vim/backup//
set undodir^=$LOCALAPPDATA/vim/undo//
set viminfofile=$LOCALAPPDATA/vim/viminfo

let g:VIMWIKI_PATH = 'H:\docs'

filetype plugin indent on

call plug#begin()
    Plug 'tpope/vim-sensible'
    Plug 'tpope/vim-vinegar'
    Plug 'tpope/vim-fugitive'
    Plug 'mileszs/ack.vim'
    Plug 'inkarkat/vim-ingo-library'
    
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    "Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'dense-analysis/ale'
    Plug 'wellle/context.vim'
    Plug 'itchyny/lightline.vim'
    Plug 'vimwiki/vimwiki'

	"themes
    Plug 'sainnhe/gruvbox-material'
    Plug 'joshdick/onedark.vim'
    Plug 'tomasr/molokai'
call plug#end()
 
set number
set splitright
set nosplitbelow
set relativenumber
set tabstop=4
set shiftwidth=4
set belloff=all
"set paste "allow copy paste
set autoindent
set scrolloff=5
set expandtab
set ignorecase
set ffs=unix,dos
set clipboard=unnamedplus
set confirm
set background=dark

hi Normal ctermbg=NONE guibg=NONE
hi NonText ctermbg=NONE guibg=NONE
hi EndOfBuffer ctermbg=NONE guibg=NONE
hi LineNr ctermbg=NONE guibg=NONE
hi SignColumn ctermbg=NONE guibg=NONE
set lazyredraw
set ttyfast
set synmaxcol=200
set updatetime=1000

" --@gui/
set guifont=Consolas:h14
set guioptions-=m
set guioptions-=T
set guioptions=Ace
set guioptions-=e
set encoding=utf-8
set fileencoding=utf-8
set nowrap
set autoindent
set termguicolors

set sessionoptions+=tabpages,globals

let g:lightline = {
      \ 'colorscheme': 'molokai',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

set noshowmode " lightline thing to remove '-- INSERT --' at bottom of screen

colorscheme retrobox 

let g:gruvbox_material_background = 'hard'

let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tabline#left_alt_sep = '|'

let g:ale_set_quickfix = 1 
let g:ale_set_loclist = 1
let g:ale_linters_explicit = 1

let g:ale_linters = {
"\   'python': ['ruff'],
\   'sql': ['sqlfluff']
"\   'ps1': ['psscriptanalyzer'],
"\   'yaml': ['yamllint']
\}
let g:ale_fixers = {
\   'python': ['ruff'],
\}

let g:ale_sql_sqlfluff_options = '--dialect tsql'

let g:vimwiki_list = [{'path': g:VIMWIKI_PATH,
                      \ 'syntax': 'markdown', 'ext': 'md'}]

let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'

let g:rustfmt_autosave = 1
 

let g:mapleader=','

map <C-w><C-b> :buffers<cr>
map <C-ö> :terminal<cr>
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

nnoremap <Leader>b :ls<cr>:b<space>
nnoremap <Leader>t :Tags<enter>
nnoremap <Leader>y :BTags<enter>
let g:NERDTreeWinPos = "right"

" <S-Tab>: completion back
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-P>" : "\<C-H>"
" <CR>: confirm completion, or insert <CR>
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"
 
nnoremap <Space><Space> :FZF <CR>

function! ToggleQuickfix()
  if empty(filter(getwininfo(), 'v:val.quickfix'))
    copen
  else
    cclose
  endif
endfunction

nnoremap <leader>c :call ToggleQuickfix()<CR>

" Add all conflicted files to quickfix, safely handling spaces
function! GitConflictsQuickfix()
    " Get list of conflicted files from Git (null-separated to handle spaces)
    let l:files = split(system("git diff --name-only --diff-filter=U -z "), "\0")

    if empty(l:files)
        echo "No conflicted files."
        return
    endif

    " Build quickfix list
    let l:qf = []
    for f in l:files
        " Skip empty entries (happens because of trailing null)
        if f == ''
            continue
        endif
        " Add entry at line 1, column 1; text empty for now
        call add(l:qf, {'filename': f, 'lnum': 1, 'col': 1, 'text': ''})
    endfor

    " Set quickfix list and open it
    call setqflist(l:qf)
    copen
endfunction

command! GitConflicts call GitConflictsQuickfix()
command! PyBuild cexpr system('uv run basedpyright') | copen

" ack.vim --- {{{

" Use ripgrep for searching ⚡️
" Options include:
" --vimgrep -> Needed to parse the rg response properly for ack.vim
" --type-not sql -> Avoid huge sql file dumps as it slows down the search
" --smart-case -> Search case insensitive if all lowercase pattern, Search case sensitively otherwise
let g:ackprg = 'rg --vimgrep'

" Auto close the Quickfix list after pressing '<enter>' on a list item
let g:ack_autoclose = 1

" Any empty ack search will search for the work the cursor is on
let g:ack_use_cword_for_empty_search = 1

" Don't jump to first match
cnoreabbrev Ack Ack!

" Maps <leader>/ so we're ready to type the search keyword
" nnoremap <Leader>/ :Ack!<Space>
nnoremap <Leader>f :Ack!<Space>
nnoremap <Leader>* :execute 'Ack! ' . expand('<cword>')<CR>
" }}}

" Navigate quickfix list with ease
nnoremap <Leader>w :cprevious<CR>
nnoremap <Leader>s :cnext<CR>

nnoremap cf :make<CR><Enter><Leader>c

" Add current file to buffer list and move to next entry
function! NetrwBufAdd(isLocal)
  try
    let l:filespec = netrw#Call('NetrwFile', netrw#Call('NetrwGetWord'))
    if filereadable(l:filespec)
      execute 'badd' ingo#compat#fnameescape(l:filespec)
    else
      echohl WarningMsg | echom "Not a readable file: " . l:filespec | echohl None
    endif
  catch /.*/
    echohl ErrorMsg | echom "Error adding file: " . v:exception | echohl None
  endtry

  " Move cursor to next entry
  try
    execute 'normal!' (b:netrw_liststyle == netrw#Expose('WIDELIST') ? 'W' : 'j')
  catch /.*/
    " Ignore movement errors silently
  endtry
  return ''
endfunction

" Remove current file buffer (if it exists) and move to next entry
function! NetrwBufRemove(isLocal)
  try
    let l:filespec = netrw#Call('NetrwFile', netrw#Call('NetrwGetWord'))
    let l:buf = bufnr(fnameescape(l:filespec))
    if l:buf > 0
      execute 'bdelete' l:buf
    else
      echohl WarningMsg | echom "Buffer not found for: " . l:filespec | echohl None
    endif
  catch /.*/
    echohl ErrorMsg | echom "Error removing buffer: " . v:exception | echohl None
  endtry

  " Move cursor to next entry
  try
    execute 'normal!' (b:netrw_liststyle == netrw#Expose('WIDELIST') ? 'W' : 'k')
  catch /.*/
    " Ignore movement errors silently
  endtry
  return ''
endfunction

" Use Tab and Shift-Tab to add/remove buffers
let g:Netrw_UserMaps = [
\   ['<Tab>', 'NetrwBufAdd'],
\   ['<S-Tab>', 'NetrwBufRemove'],
\]

set grepprg=rg\ --vimgrep

" compilers
autocmd FileType python setlocal makeprg=uv\ run\ ruff\ check\ --quiet\ --output-format=concise
"autocmd FileType python setlocal errorformat=%f:%l%c:\ %m

inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" --@main-end/

function! VimWikiTodo()
    if !exists('g:VIMWIKI_PATH')
        echo "g:VIMWIKI_PATH is not set"
        return
    endif

    let l:cmd = 'rg --vimgrep --no-heading --smart-case ' .
                \ shellescape('\[[^X]\] TODO') . ' ' .
                \ shellescape(g:VIMWIKI_PATH)

    let l:result = system(l:cmd)

    if v:shell_error
        echo "No TODOs found (or rg error)"
        return
    endif

    cexpr l:result
    copen
endfunction

command! TODO call VimWikiTodo()

function! VimWikiTicketsTodo()
    if !exists('g:VIMWIKI_PATH')
        echo "g:VIMWIKI_PATH is not set"
        return
    endif

    let l:cmd = 'rg --vimgrep --no-heading --smart-case ' .
                \ shellescape('\[[^X]\] TODO DRIV') . ' ' .
                \ shellescape(g:VIMWIKI_PATH)

    let l:result = system(l:cmd)

    if v:shell_error
        echo "No TODO tickets found (or rg error)"
        return
    endif

    cexpr l:result
    copen
endfunction

command! TICKETS call VimWikiTicketsTodo()

function! DiarySearch(term)
    execute 'grep ' . shellescape(a:term) . ' ' . shellescape(g:VIMWIKI_PATH) . '\diary'
endfunction

command! -nargs=1 D call DiarySearch(<q-args>)

augroup makeprg_linters
    autocmd!

    autocmd FileType yaml setlocal makeprg=yamllint\ -f\ parsable\ %
    autocmd FileType yml setlocal makeprg=yamllint\ -f\ parsable\ %

    autocmd FileType ps1 setlocal makeprg=powershell\ -NoProfile\ -Command\ "Invoke-ScriptAnalyzer\ -Path\ '%'\ |\ Format-Table\ -AutoSize"
    autocmd FileType ps1 setlocal errorformat=%f:%l:%c:\ %t%*[^:]:\ %m

augroup END

cnoreabbrev <expr> git (getcmdtype() == ':' && getcmdline() == 'git') ? 'Git' : 'git'

