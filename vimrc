call pathogen#infect()
call pathogen#helptags()

if has("mouse")
    set mouse=a
    set mousehide
endif

set background=dark         " All terminals have dark backgrounds
colorscheme solarized       " I like solarized
set tabstop=4               " Number of visual spaces per tab
set softtabstop=4           " Number of spaces to use when tab editing
set shiftwidth=4            " >> and << should go forward / back 1 tab
set expandtab               " Tabs are spaces
set number                  " Show line numbers
set cursorline              " Hihgligh the current line
filetype plugin indent on   " Indent please
syntax enable               " Syntax highlighting 
set wildmenu                " Enable autocomplete for command
set wildmode=list:longest,full
set showmatch               " Highlight closing parentheses
set nowrap                  " Don't wrap lines by default

" Search options
set hlsearch                " Highlight search results
set smartcase               " Search strings that are all-lowercase will do a case-insensitive search
set incsearch               " Incremental search
nnoremap <CR> :noh<CR><CR>  " Clear search highlight by hitting enter

"Disable swap
set nobackup
set nowritebackup
set noswapfile

set laststatus=2
set statusline=[%l,%v\ %P%M]\ %f\ %y%r%w[%{&ff}]%{fugitive#statusline()}\ %b\ 0x%B
"set t_Co=256
"call togglebg#map("<F5>")

" Save Taskpaper files automatically and use light background
autocmd BufLeave,FocusLost *.taskpaper w
autocmd Filetype taskpaper set background=light

" Run wrapwithtag.vim script when opening html docs (shouldn't this be a
" filetype plugin? meh.)
autocmd Filetype html,xml,aspvbs runtime scripts/wrapwithtag.vim

" Use Groovy syntax highlighting for gradle buildfiles
au BufNewFile,BufRead *.gradle setf groovy

" Set up NERDTree keybinds and options
let g:NERDTreeDirArrows=0
map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
map <F3> :NERDTreeFind<CR>
let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0

"Load the NERDTree on startup and put the cursor in the main window
"autocmd VimEnter * NERDTree
"autocmd VimEnter * wincmd p

autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
function! s:CloseIfOnlyNerdTreeLeft()
    if exists("t:NERDTreeBufName")
        if bufwinnr(t:NERDTreeBufName) != -1
            if winnr("$") == 1
                q
            endif
        endif
    endif
endfunction

:set pastetoggle=<F11>

" Set up taglist keybinds
map <F5> :TlistToggle<CR>
let Tlist_Use_Right_Window=1

command! -range=% Entities :<line1>,<line2>call Entities()
function! Entities()
    silent s/À/\&Agrave;/eg
    silent s/Á/\&Aacute;/eg
    silent s/Â/\&Acirc;/eg
    silent s/Ã/\&Atilde;/eg
    silent s/Ä/\&Auml;/eg
    silent s/Å/\&Aring;/eg
    silent s/Æ/\&AElig;/eg
    silent s/Ç/\&Ccedil;/eg
    silent s/È/\&Egrave;/eg
    silent s/É/\&Eacute;/eg
    silent s/Ê/\&Ecirc;/eg
    silent s/Ë/\&Euml;/eg
    silent s/Ì/\&Igrave;/eg
    silent s/Í/\&Iacute;/eg
    silent s/Î/\&Icirc;/eg
    silent s/Ï/\&Iuml;/eg
    silent s/Ð/\&ETH;/eg
    silent s/Ñ/\&Ntilde;/eg
    silent s/Ò/\&Ograve;/eg
    silent s/Ó/\&Oacute;/eg
    silent s/Ô/\&Ocirc;/eg
    silent s/Õ/\&Otilde;/eg
    silent s/Ö/\&Ouml;/eg
    silent s/Ø/\&Oslash;/eg
    silent s/Ù/\&Ugrave;/eg
    silent s/Ú/\&Uacute;/eg
    silent s/Û/\&Ucirc;/eg
    silent s/Ü/\&Uuml;/eg
    silent s/Ý/\&Yacute;/eg
    silent s/Þ/\&THORN;/eg
    silent s/ß/\&szlig;/eg
    silent s/à/\&agrave;/eg
    silent s/á/\&aacute;/eg
    silent s/â/\&acirc;/eg
    silent s/ã/\&atilde;/eg
    silent s/ä/\&auml;/eg
    silent s/å/\&aring;/eg
    silent s/æ/\&aelig;/eg
    silent s/ç/\&ccedil;/eg
    silent s/è/\&egrave;/eg
    silent s/é/\&eacute;/eg
    silent s/ê/\&ecirc;/eg
    silent s/ë/\&euml;/eg
    silent s/ì/\&igrave;/eg
    silent s/í/\&iacute;/eg
    silent s/î/\&icirc;/eg
    silent s/ï/\&iuml;/eg
    silent s/ð/\&eth;/eg
    silent s/ñ/\&ntilde;/eg
    silent s/ò/\&ograve;/eg
    silent s/ó/\&oacute;/eg
    silent s/ô/\&ocirc;/eg
    silent s/õ/\&otilde;/eg
    silent s/ö/\&ouml;/eg
    silent s/ø/\&oslash;/eg
    silent s/ù/\&ugrave;/eg
    silent s/ú/\&uacute;/eg
    silent s/û/\&ucirc;/eg
    silent s/ü/\&uuml;/eg
    silent s/ý/\&yacute;/eg
    silent s/þ/\&thorn;/eg
    silent s/ÿ/\&yuml;/eg
    silent s/’/\&#x92;/eg
endfunction

" for typos
map :W :w
map :E :e
map :X :x
let g:pydiction_location='~/.vim/bundle/Pydiction/complete-dict'

" Uncomment the following to have Vim jump to the last position when                                                       
" reopening a file
if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
                \| exe "normal! g'\"" | endif
endif

" For snippet_complete marker.
if has('conceal')
    set conceallevel=2 concealcursor=i
endif
"Highlight problematic whitespace
set list
set listchars=tab:,.,trail:.,extends:#,nbsp:.

"Allow tabluarizing of puppet files

function! CustomTabularPatterns()
    if exists('g:tabular_loaded')
        AddTabularPattern! block /=>
        AddTabularPattern! assignment      / = /l0
        AddTabularPattern! chunks          / \S\+/l0
        AddTabularPattern! colon           /:\zs /l0
        AddTabularPattern! comma           /^[^,]*,/l1
        AddTabularPattern! hash            /^[^>]*\zs=>/
        AddTabularPattern! options_hashes  /:\w\+ =>/
        AddTabularPattern! symbol          /^[^:]*\zs:/l1r0
        AddTabularPattern! symbols         / :/l0
        AddTabularPattern! doublequote     /"/l5c1
    endif
endfunction
autocmd VimEnter * call CustomTabularPatterns()
