set nu
set nobackup
set undofile
set noswapfile
set autochdir
set autoindent
set softtabstop=4
set expandtab
set tabstop=4 set shiftwidth=4
set ignorecase
set smartcase
set incsearch
set hlsearch
set scrolloff=15


let mapleader = ' '
imap <C-h> <Left>
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-l> <Right>
imap kj <Esc>

nmap H ^
nmap U <C-r>
vmap H ^
nmap L $
vmap L $
vmap gg gg^
vmap G G$
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz

vmap < <gv
vmap > >gv
nmap ; :
nmap <leader><leader> :nohlsearch<CR>
nmap <leader>w :w<CR>
nmap <leader>q :q!<CR>
nmap <leader>x :wq!<CR>
nmap <C-h> <C-w><left>
nmap <C-j> <C-w><down>
nmap <C-k> <C-w><Up>
nmap <C-l> <C-w><Right>
nmap <C-Left> :vertical resize -2<CR>
nmap <C-Down> :resieze +2<CR>
nmap <C-Up> :resize -2<CR>
nmap <C-Right> :vertical resize +2<CR>
namp <leader>c :!

augroup strip_whitespace_on_leave
    autocmd BufWritePre * %s/\s\+$//e
augroup END
