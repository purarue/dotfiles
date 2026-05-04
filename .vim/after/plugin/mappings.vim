nnoremap / /\v
vnoremap / /\v

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
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz
nnoremap n nzz
nnoremap N Nzz
nnoremap G Gzz
nnoremap gg ggzz
nnoremap <C-i> <C-i>zz
nnoremap <C-o> <C-o>zz
nnoremap % %zz
nnoremap * *zz
nnoremap # #zz

nnoremap !B :.!bash<CR>
vnoremap !B :.!bash<CR>

" append to line
nnoremap J mzJ`z
nnoremap <leader><CR> :terminal<CR>

" start a :%s/ with selected text, prompting for replacement
vnoremap <C-n> y':%s/<C-r>"//gc<Left><Left><Left>
" in normal mode, use next word as search term
nnoremap <C-n> yiw:%s/<C-r>"//gc<Left><Left><Left>
" just start a search/replace and move me to where I can start typing

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
nnoremap <leader>X :w<CR>:!chmod +x %<CR>:edit<CR>

" quickfix
nnoremap <leader>j :cnext<CR>
nnoremap <leader>k :cnext<CR>
