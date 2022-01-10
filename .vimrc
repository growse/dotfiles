call plug#begin()
Plug 'lifepillar/vim-solarized8'
Plug 'tpope/vim-sensible'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/syntastic'
call plug#end()

filetype plugin indent on

let g:rustfmt_autosave = 1

"Vim should remember the last point in the file on re-opening
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"Set theming and colours
syntax enable
set background=dark
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
autocmd vimenter * ++nested colorscheme solarized8
