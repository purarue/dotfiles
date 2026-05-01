" vim ft=vimrc
if empty(glob('~/.vim/autoload/plug.vim'))
  if executable('curl')
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  else
    echo("could not find curl to install plug.vim!")
  endif
endif

let g:is_posix = 1
set background=dark

" use this command to create banners
" echo banner | boxes -pv1h3 -dshell | tr '#' '"'

let mapleader =" "

"""""""""""""""
"             "
"   PLUGINS   "
"             "
"""""""""""""""

call plug#begin('~/.local/share/vim/plugged')
Plug 'sainnhe/everforest'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'mbbill/undotree'
Plug 'airblade/vim-rooter'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'itchyny/lightline.vim'
" enable when im testing with :StartupTime
" Plug 'dstein64/vim-startuptime'
call plug#end()

colorscheme everforest

" set backup directory elsewhere
set nobackup
set nowritebackup
if !isdirectory($HOME."/.local/share/vim/swap")
	silent! execute "!mkdir -p ~/.local/share/vim/swap"
endif
set directory=~/.local/share/vim/swap

syntax enable
filetype plugin indent on

" manually set encoding
set encoding=utf-8

" dont be compatibble with vi
set nocompatible

" disable completions from #include files
set complete-=i

set list
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+,eol:¬

" automatically read when a file is changed from outside of vim
set autoread

" command-lines that are remembered in history
set history=10000

" how many tabs can be opened with -p flag from CLI
set tabpagemax=50
set nrformats-=octal " numbers for C-X C-A commands

" cursor motion
set scrolloff=3 "min number of lines to keep above/below cursor
set sidescroll=1
set sidescrolloff=2
set backspace=indent,eol,start
set matchpairs+=<:>
runtime! macros/matchit.vim

" make escape key more responsive by decreasing wait time for escape sequence
set ttimeout
set ttimeoutlen=100

" dont save swapfile
set noswapfile

set novisualbell

" shorten some messages
set shortmess+=Icwa

" legacy behaviour that breaks plugin maps
set nolangremap

" show extra info in popup menu when doing ins-completion
set completeopt+=popup

" unset C ftplugin customizations
set path=.,, define= include=

" unload buffers when they're abandoned
set hidden

" last line
set showmode
set showcmd

" dont add two spaces after a .
set nojoinspaces

" enable mouse in specific modes
set mouse=nvi
set mousemodel=popup_setpos

" view/session options
set viewoptions+=unix,slash
set viewoptions-=options,curdir
set sessionoptions+=unix,slash
set sessionoptions-=options,curdir

" disable folds
set nofoldenable

" splits
set splitbelow
set splitright

" dont use tempfile for shell commands
set noshelltemp
set nostartofline
" jump to the previously used window when jumping to errors with quickfix cmds
set switchbuf=uselast
" assume fast rendering terminals
set ttyfast
" always have status line
set laststatus=2
" show location in menu bar
set ruler
" prevents truncated yanks, deletes, etc.
" makes sure that you can lots of lines across
" files/vim instances without truncating the buffer
set viminfo='20,<1000,s1000

" how to display when lines are truncated
set display+=truncate


" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif

" whitespace
" TODO: maybe use vim-sleuth
set wrap
set textwidth=0 wrapmargin=0 " stop line wrapping
set formatoptions+=tjn1
set tabstop=2 shiftwidth=2 softtabstop=2
set expandtab
set smartindent
set noshiftround
set smarttab
set autoindent

" set repprg to rg
set grepprg=rg\ --vimgrep\ --no-heading

" undodir
set undodir=$HOME/.cache/undodir
set undofile

" searching
nnoremap / /\v
vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
" use <C-l> to unhighlight
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

set path+=**
" wildmenu opts
set wildmenu
set wildmode=longest,list,full
set wildignore+=*__pycache__/*
set wildignore+=*.mypy_cache/*
set wildignore+=*.pytest_cache/*
set wildignore+=*egg-info/*
set wildignore+=*_build/*
set wildignore+=**/coverage/*
set wildignore+=**/node_modules/*
set wildignore+=**/dist/*
set wildignore+=**/build/*
set wildignore+=**/.git/*

set number relativenumber

" set termguicolors "TODO: make sure this works on remote machines while ssh'd?, background color doesnt work?

" mappings

map <leader>s :set spell!<CR>

" move up/down in paragraphs/long lines
nnoremap j gj
nnoremap k gk

" Wrap long lines of text (use Qq to run)
" 5Qq to do multiple lines
" Qip to format paragraph
nnoremap Q gq

" center/fix cursor when jumping around text
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" copy visual selection to clipboard
vmap <leader>c "+y
vmap <leader>y "+y
nnoremap <leader>y V"+y

" open netrw like a sidebar file manager
nnoremap <leader>e :wincmd v<bar> :Explore <bar> :vertical resize 30<CR>
" open netrw full screen
nnoremap <leader>E :Explore<CR>

inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" swap to previous buffer
" map <leader><leader> :bprevious<CR>

" nicer binding for window management
map <leader>w <C-W>
" can use <leader>w+ and <leader>w- to increase
" vertical resizing
nnoremap <leader>= :vertical resize +5<CR>
nnoremap <leader>- :vertical resize -5<CR>

nnoremap <leader>+ :wincmd +<CR>
nnoremap <leader>_ :wincmd -<CR>

" undotree
nnoremap <leader>u :UndotreeToggle<CR>

" fzf
map <leader>b :Buffers<CR>
map <leader>f :Files<CR>
map <leader>l :Lines<CR>
map <C-p> :GitFiles<CR>
" match all lines/files recursively using the_silver_searcher
map <leader>r :Ag<CR>

" git
" git related bindings

" jumping around the git gutter
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
" preview changed git hunks
nmap <leader>gP <Plug>(GitGutterPreviewHunk)

" stage hunk
nmap <leader>gA <Plug>(GitGutterStageHunk)

" fugitive (git)
nmap <leader>gi :G<CR>:wincmd _<CR>
nmap <leader>gp :Git push<CR>
nmap <leader>gll :Git pull<CR>
nmap <leader>glo :Git log<CR>
" windcmd _ full screens  can <C-W>= to reset
nmap <leader>gc :Git commit<CR>:wincmd _<CR>
nmap <leader>gdd :Git diff<CR>:wincmd _<CR>
nmap <leader>gds :Git diff --staged<CR>:wincmd _<CR>
nmap <leader>gdh :Git diff HEAD~1 HEAD<CR>:wincmd _<CR>
" --update, only add item which are already in the index
nmap <leader>gaa :Git add -u<CR>
" add everything, adds untracked files
nmap <leader>gaA :Git add --all<CR>
" add everything, but prompt me with --patch
nmap <leader>gap :Git add --all --patch<CR>
nmap <leader>gst :Git status<CR>
nmap <leader>gsu :Git status -u<CR>
nmap <leader>grs :Git reset<CR>
nmap <leader>grhh :Git reset --hard HEAD<CR>

" for picking which files to merge from while resolving merge conflicts
" https://youtu.be/PO6DxfGPQvw?t=292
" middle is what the final merged file is
" gj to pick hunk from the right (under right index)
" gf to pick hunk form the left (under left index)
nmap <leader>gj :diffget //3<CR>
nmap <leader>gf :diffget //2<CR>

function! ShowDocumentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  endif
endfunction

" nnoremap <silent> K :call ShowDocumentation()<CR>

let g:rg_derive_root='true'

" runtime ftplugin/man.vim

" dont show mode, lightline does it already
set noshowmode

" TODO: set custom spellfile
