call plug#begin()
Plug 'lifepillar/vim-solarized8'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/syntastic'
Plug 'udalov/kotlin-vim'
Plug 'Yggdroot/indentLine'
Plug 'dense-analysis/ale'
call plug#end()

filetype plugin indent on

let g:rustfmt_autosave = 1

" Pretty indent markers
let g:indentLine_char = '⦙'

" Vim should remember the last point in the file on re-opening
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Set theming and colours
syntax enable
set background=dark
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
autocmd vimenter * ++nested colorscheme solarized8

" For YAML files, we want indents of two spaces
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" Linting
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_lint_on_text_changed = 'never'
