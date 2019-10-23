set modelines=1                 " tells VIM to check the modline at the end of file for certain settings

call plug#begin()
Plug 'sjl/badwolf'              " color schemes
Plug 'joshdick/onedark.vim'
Plug 'tomasiser/vim-code-dark'  " use codedark in colorscheme
Plug 'tpope/vim-repeat'         " repeat any plugin motion (if they support it)
Plug 'sjl/gundo.vim'            " show tree of undo
Plug 'mileszs/ack.vim'          " search source files
Plug 'ctrlpvim/ctrlp.vim'       " fuzzy search
Plug 'jeffkreeftmeijer/vim-numbertoggle' " automatically swith to absolute line numbers when in insert mode
Plug 'kana/vim-operator-user'   " for all operators
Plug 'kana/vim-textobj-user'    " needed for other textobj
Plug 'glts/vim-textobj-comment' " enable comment object
Plug 'rhysd/vim-operator-surround'      " operator to deal with surroundings
Plug 'rhysd/vim-textobj-anyblock'       " match internal blocks of things surrounded by common parenthesies
Plug 'vim-scripts/ReplaceWithRegister'  " replace block with content of register
Plug 'christoomey/vim-titlecase'        " title case block
Plug 'christoomey/vim-sort-motion'      " sort blocks
Plug 'kana/vim-textobj-indent'          " indent text object
Plug 'kana/vim-textobj-entire'          " entire doc
Plug 'kana/vim-textobj-line'            " entire doc
call plug#end()


filetype plugin indent on       " detect file type, loads right plugin and indent
syntax enable                   " enable syntax processing (enabled default by Plug)

set termguicolors               " set terminal to True Color

colorscheme codedark            " pick the one to use
let g:airline_theme = 'codedark'    " use same theme for airline

set tabstop=4                   " number of visual spaces per TAB
set softtabstop=4               " number of spaces in tab when editing
set expandtab                   " tabs are spaces

set number relativenumber       " show line numbers
set showcmd                     " show command in bottom bar

set cursorline                  " highlight current line
hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white "Set curson not to conflict with syntax highlight

set hidden                      " when switching buffer, mark it as hidden instad of complaining

set wildmenu                    " visual autocomplete for command menu
set lazyredraw                  " redraw only when we need to (not in macros)
set showmatch                   " highlight matching [{()}]

set incsearch                   " search as characters are entered
set hlsearch                    " highlight matches

set formatprg=par\ -w100        " enable use of Berkley par (on PATH) to format paragraphs

set clipboard=unnamedplus

" Use SharpKey to remap keys (Caps Lock is ESC, Right ALT is CTRL)
let mapleader = "\<Space>"          " leader is space

nnoremap <leader><space> :nohlsearch<CR> " map space to turn off search highlight

set foldenable                  " enable folding
set foldlevelstart=10           " open most folds by default
set foldnestmax=10              " 10 nested fold max
set foldmethod=indent           " fold based on indent level

nnoremap gV `[v`]                           " highlight last inserted text
nnoremap <leader>u :GundoToggle<CR>         " toggle gundo

nnoremap <leader>ev :e $MYVIMRC<CR>         " open vimrc file
nnoremap <leader>rv :execute "source " .  $MYVIMRC<CR>  " source vimrc file

nnoremap <leader>s :mksession<CR>   " save session

nnoremap <leader>a :Ack

if executable('ag')         " set default searcher for ack to The Silver Searcher
  let g:ackprg = 'ag --vimgrep'
endif

" Titlecase redefine maps
let g:titlecase_map_keys = 0

nmap gt <Plug>Titlecase
vmap gt <Plug>Titlecase
nmap gtt <Plug>TitlecaseLine

" operator surround settings
map sa <Plug>(operator-surround-append)
map sd <Plug>(operator-surround-delete)
map sr <Plug>(operator-surround-replace)

" mix of surround and anyblock
nmap sdd <Plug>(operator-surround-delete)<Plug>(textobj-anyblock-a)
nmap srr <Plug>(operator-surround-replace)<Plug>(textobj-anyblock-a)

" CtrlP settings
let g:ctrlp_match_window = 'bottom,order:ttb'   " order match files top bottom
let g:ctrlp_switch_buffer = 0                   " always open in new buffer
let g:ctrlp_working_path_mode = 0               " CtrlP accept changing working dir
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'  " Use AG for search

" allows cursor change in tmux mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Move backup to tmp folder
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup

" toggle between number and relativenumber
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

" strips trailing whitespace at the end of files. this
" is called on buffer write in the autogroup above.
function! <SID>StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction

function! ListLeaders()
     silent! redir @a
     silent! nmap <LEADER>
     silent! redir END
     silent! new
     silent! put! a
     silent! g/^s*$/d
     silent! %s/^.*,//
     silent! normal ggVg
     silent! sort
     silent! let lines = getline(1,"$")
endfunction

" vim:foldmethod=marker:foldlevel=0
