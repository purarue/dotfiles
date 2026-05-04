" fzf
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>l :Lines<CR>
nnoremap <C-p> :GitFiles<CR>
" match all lines/files recursively using the_silver_searcher
nnoremap <leader>r :Ag<CR>

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
