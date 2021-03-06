" Include user's local pre .vimrc config
if filereadable(expand("~/.vimrc.pre"))
  source ~/.vimrc.pre
endif

let mapleader = ","

if (!has('nvim'))
  set ttymouse=xterm2
endif

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set encoding=utf-8          " The encoding displayed
set fileencoding=utf-8      " The encoding written to file
set t_Co=256
let g:solarized_termcolors=256
set ttyfast                 " Faster redrawing
set lazyredraw              " Only redraw when necessary
set cursorline              " Find the current line quickly.

" don't use arrowkeys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" really, just don't
inoremap <Up>    <NOP>
inoremap <Down>  <NOP>
inoremap <Left>  <NOP>
inoremap <Right> <NOP>

call plug#begin('~/.vim/plugged')

  Plug 'neomake/neomake'       " Asyncronous activities
  Plug 'sheerun/vim-polyglot'  " Multiple language syntax highlighting
  Plug 'w0rp/ale'              " Asyncronous Linting/fixing
  Plug 'scrooloose/nerdtree'   " File browser :help nerdtree
  Plug 'rizzatti/dash.vim'     " Search Dash app from vim :help dash
  Plug 'airblade/vim-gitgutter'  " A Vim plugin which shows a git diff in the gutter (sign column) and stages/undoes hunks.
  Plug 'altercation/vim-colors-solarized' " Solarized color scheme
  Plug 'vim-airline/vim-airline'	" Lean & mean status/tabline for vim that's light as air.
  Plug 'vim-airline/vim-airline-themes'	" Themes for Airline
  Plug 'edkolev/tmuxline.vim'  " Simple tmux statusline generator with support for powerline symbols and statusline / airline / lightline integration
  Plug 'godlygeek/tabular'     " Script for text filtering and alignment :help tabular
  Plug 'vim-syntastic/syntastic' " syntax highlighting engine :help syntastic
  Plug 'tpope/vim-fugitive'    " Git commands :help fugitive
  Plug 'tpope/vim-sensible'    " Sensible defaults for VIM
  Plug 'tpope/vim-commentary'  " Bulk comment-out support :help commentary
  Plug 'junegunn/fzf'          " Fuzzy Finder
  Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}

call plug#end()

" fix files on save
let g:ale_fix_on_save = 1

" lint after 1000ms after changes are made both on insert mode and normal mode
let g:ale_lint_on_text_changed = 'always'
let g:ale_lint_delay = 1000

" fixer configurations
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\}

" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1

" Set encoding
set encoding=utf-8

" Whitespace stuff
set nowrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set list listchars=tab:\ \ ,trail:·

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Tab completion for VIM commands and show autocomplete options
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*
set showcmd

" Highlight tabs and spaces while typing
highlight LiteralTabs ctermbg=darkgreen guibg=darkgreen
match LiteralTabs /\s\ /
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" NERDTree configuration
let NERDTreeIgnore=['\.pyc$', '\.rbc$', '\~$']
map <Leader>n :NERDTreeToggle<CR>
let g:NERDTreeQuitOnOpen=1  " close NERDTree after a file is opened

" FZF support
set rtp+=/usr/local/opt/fzf

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

" Default color scheme
syntax enable
set background=dark
colorscheme solarized

" Create/set backup and tmp dirs if they didn't exist
function! InitBackupDir()
  let l:parent = $HOME . '/' . '.vim/'
  let l:backup = l:parent . 'backup/'
  let l:tmp = l:parent . 'tmp/'
  if exists('*mkdir')
    if !isdirectory(l:parent)
      call mkdir(l:parent)
    endif
    if !isdirectory(l:backup)
      call mkdir(l:backup)
    endif
    if !isdirectory(l:tmp)
      call mkdir(l:tmp)
    endif
  endif
  let l:missing_dir = 0
  if isdirectory(l:tmp)
    execute 'set backupdir=' . escape(l:backup, ' ') . '/,.'
  else
    let l:missing_dir = 1
  endif
  if isdirectory(l:backup)
    execute 'set directory=' . escape(l:tmp, ' ') . '/,.'
  else
    let l:missing_dir = 1
  endif
  if l:missing_dir
    echo 'Warning: Unable to create backup directories:' l:backup 'and' l:tmp
    echo 'Try: mkdir -p' l:backup
    echo 'and: mkdir -p' l:tmp
    set backupdir=.
    set directory=.
  endif
endfunction
call InitBackupDir()

" Unlimited persistent undo but clear out older than 90 days
set undofile
set undodir=~/.vim/tmp
let s:undos = split(globpath(&undodir, '*'), "\n")
call filter(s:undos, 'getftime(v:val) < localtime() - (60 * 60 * 24 * 90)')
call map(s:undos, 'delete(v:val)')

" Automatically resize splits when resizing MacVim window
if has("gui_running")
  autocmd VimResized * wincmd =
endif

" Convert :W to :w because I fat-finger so often
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))

" Include user's local vim config
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

" Open NERDTree if VIM was called w/out any args
autocmd VimEnter * if !argc() | NERDTree | endif

" use <tab> for trigger completion and navigate to next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

