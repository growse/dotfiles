call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/syntastic'
call plug#end()

syntax enable
filetype plugin indent on

let g:rustfmt_autosave = 1
