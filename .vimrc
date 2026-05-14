" vim ft=vimrc
"
" bootstrap plugin manager
if empty(glob('~/.vim/autoload/plug.vim'))
  if executable('curl')
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  else
    echo("could not find curl to install plug.vim!")
  endif
endif

let g:is_posix = 1

" colorscheme configuration, set before loading plugins
let g:lightline = {'colorscheme': 'everforest'}
let g:everforest_transparent_background = 1  " disable custom background, use terminal color
set termguicolors

if $TERMINAL_THEME ==? 'light'
  set background=light
else
  set background=dark
endif

" $ON_OS is a variable I set on my machines to determine if
" I'm on a local machine. It's used in my configuration to determine
" if I should install additional plugins or do custom functionalilty
" that depends on my local setup

let g:on_os = $ON_OS
let g:is_local = !empty(g:on_os)  

" use this command to create banners
" echo banner | boxes -pv1h3 -dshell | tr '#' '"'

let g:mapleader=" "
" TODO: set maplocalleader?

"""""""""""""""
"             "
"   PLUGINS   "
"             "
"""""""""""""""

call plug#begin('~/.local/share/vim/plugged')
Plug 'sainnhe/everforest'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'mbbill/undotree'
Plug 'airblade/vim-rooter'
Plug 'jasonccox/vim-wayland-clipboard'
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'
Plug 'https://gitlab.com/dbeniamine/todo.txt-vim.git'
" enable when im testing with :StartupTime
" Plug 'dstein64/vim-startuptime'
call plug#end()

colorscheme everforest
let g:rg_derive_root='true'

"""""""""""""""
"             "
"   OPTIONS   "
"             "
"""""""""""""""

" set backup directory elsewhere
set nobackup
set nowritebackup
if !isdirectory($HOME."/.local/share/vim/swap")
	silent! execute "!mkdir -p ~/.local/share/vim/swap"
endif
set directory=~/.local/share/vim/swap

if !isdirectory($HOME."/.local/share/vim/view")
  silent! execute "!mkdir -p ~/.local/share/vim/view"
endif
set viewdir=~/.local/share/vim/view

syntax enable
filetype plugin indent on

" manually set encoding
set encoding=utf-8

set clipboard=unnamedplus

" dont be compatibble with vi
set nocompatible

" these are the defaults, modelineexpr is off so arbitrary stuff
" does not get run in modelines. modelines are fine, see :help modeline for more
" set modeline
" set nomodelineexpr

" disable completions from #include files
set complete-=i

set list
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+,eol:¬
set breakindent " wrapped lines indent
set signcolumn=yes
set linebreak
" -- Don't show `~` outside of buffer
" set fillchars=eob:\  

" automatically read when a file is changed from outside of vim
set autoread

" command-lines that are remembered in history
set history=10000

" how many tabs can be opened with -p flag from CLI
set tabpagemax=50
set nrformats-=octal " numbers for C-X C-A commands

" cursor motion
set scrolloff=4 "min number of lines to keep above/below cursor
set sidescroll=1
set sidescrolloff=5
set backspace=indent,eol,start
set matchpairs+=<:>
set showmatch " cursor jumps when matching brackets
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
set infercase

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
set sessionoptions-=curdir

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
set wrap
set textwidth=0 wrapmargin=0 " stop line wrapping
set formatoptions=tcqrnj1
set tabstop=2 shiftwidth=2 softtabstop=2
set expandtab
set smartindent
set noshiftround
set smarttab
set autoindent

" set repprg to rg
set grepprg=rg\ --vimgrep\ --no-heading

" undodir
if !isdirectory($HOME."/.cache/vim/undodir")
	silent! execute "!mkdir -p ~/.cache/vim/undodir"
endif
set undodir=$HOME/.cache/vim/undodir
set undofile " save undo history across file closes

" searching
set hlsearch
set incsearch
set ignorecase
set smartcase
" use <C-l> to unhighlight
nnoremap <silent> <C-l> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

" dont show mode, lightline does it already
set noshowmode

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


"""""""""""""""""""""""
"                     "
"   PLUGIN MAPPINGS   "
"                     "
"""""""""""""""""""""""

" runtime ftplugin/man.vim

if !empty($NVIM_SPELLFILE)
  set spellfile=$NVIM_SPELLFILE
  command! Spellfile :edit $NVIM_SPELLFILE
endif

function s:UnderlineColors()
  highlight clear SpellBad
  highlight SpellBad cterm=underline,bold
endfunction

" underline highlights, make sure the change to highlights
" gets called whenever the colorscheme is changed
augroup spell_color
  autocmd!
  autocmd ColorScheme * call s:UnderlineColors()
augroup END
" call once to toggle on
call s:UnderlineColors()
" disable capitlization checking
set spellcapcheck=

autocmd BufWinEnter,WinEnter term://* startinsert

" TODO: move to a ftdetect file?
augroup vimCustomFiletypes
	autocmd!
	autocmd BufNewFile,BufRead todo.txt,done.txt :setfiletype todo
augroup end

" TODO: add custom syntax/ftplugin files?
