call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/syntastic'
call plug#end()

syntax enable
filetype plugin indent on

let g:rustfmt_autosave = 1

"Vim should remember the last point in the file on re-opening
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
