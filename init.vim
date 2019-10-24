" => PLUGINs --------------------------------------------------------- {{{1
call plug#begin()
Plug 'sjl/badwolf'                      " color schemes
Plug 'joshdick/onedark.vim'
Plug 'tomasiser/vim-code-dark'          " use codedark in colorscheme
Plug 'tpope/vim-repeat'                 " repeat any plugin motion (if they support it)
Plug 'sjl/gundo.vim'                    " show tree of undo
Plug 'mileszs/ack.vim'                  " search source files
Plug 'ctrlpvim/ctrlp.vim'               " fuzzy search
Plug 'jeffkreeftmeijer/vim-numbertoggle' " automatically swith to absolute line numbers when in insert mode
Plug 'kana/vim-operator-user'           " for all operators
Plug 'kana/vim-textobj-user'            " needed for other textobj
Plug 'glts/vim-textobj-comment'         " enable comment object
Plug 'rhysd/vim-operator-surround'      " operator to deal with surroundings
Plug 'rhysd/vim-textobj-anyblock'       " match internal blocks of things surrounded by common parenthesies
Plug 'vim-scripts/ReplaceWithRegister'  " replace block with content of register
Plug 'christoomey/vim-titlecase'        " title case block
Plug 'christoomey/vim-sort-motion'      " sort blocks
Plug 'kana/vim-textobj-indent'          " indent text object
Plug 'kana/vim-textobj-entire'          " entire doc
Plug 'kana/vim-textobj-line'            " a line
Plug 'dense-analysis/ale'               " Async lint engine
Plug 'takac/vim-hardtime'               " can't press hjklupdownleftright twice in 1 second.
Plug 'powerman/vim-plugin-autosess'     " creates session file automatically if more than 1 windows open
Plug 'neoclide/coc.nvim', {'branch': 'release'} " completion manager
Plug 'SirVer/ultisnips'                 " snippets support for many lanuguages
Plug 'OmniSharp/omnisharp-vim'          " C# support
Plug 'nickspoons/vim-sharpenup'         " Add bulb for actions and mappings
call plug#end()

" => GENERAL SETTINGS --------------------------------------------------------- {{{1

filetype plugin indent on       " detect file type, loads right plugin and indent
syntax enable                   " enable syntax processing (enabled default by Plug)
set termguicolors               " set terminal to True Color
colorscheme codedark            " pick the one to use

set tabstop=4                   " number of visual spaces per TAB
set softtabstop=4               " number of spaces in tab when editing
set expandtab                   " tabs are spaces
set shiftwidth=4                " use 4 spaces for '>'

set number relativenumber       " show line numbers
set showcmd                     " show command in bottom bar
set cursorline                  " highlight current line
hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white "Set curson not to conflict
set hidden                      " when switching buffer, mark it as hidden instad of complaining
set wildmenu                    " visual autocomplete for command menu
set lazyredraw                  " redraw only when we need to (not in macros)
set showmatch                   " highlight matching [{()}]
set formatprg=par\ -w100        " enable use of Berkley par (on PATH) to format paragraphs
set clipboard=unnamedplus       " unifies clipboard with system
set history=1000                " larger history of commands, can't hurt
set spell                       " turns spell check on

set colorcolumn=100             " shade column to help wrapping text correctly
set textwidth=100

set incsearch                   " search as characters are entered
set hlsearch                    " highlight matches
set smartcase                   " ignore case if string is all lowercase, otherwise case sensitive
set gdefault                    " search replace globally be default

" disable automatically adding leading comments
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" automatically resize vertical splits to maximize current split
au WinEnter * :set winfixheight
au WinEnter * :wincmd =

au FocusLost * :wa              " save on losing focus

" allows cursor change in tmux mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

set undodir=~/.tmp/undodir      " set unfo file location
set undofile

" Move backup to tmp folder
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup

" => PLUGIN  SETTINGS --------------------------------------------------------- {{{1

" => OMNISHARP SETTINGS --------------------------------------------------------{{{2
" Hack because of https://github.com/OmniSharp/omnisharp-vim/issues/468#issuecomment-502325220
let g:OmniSharp_server_path = 'C:\dev\OmniSharpHack\bin\Debug\netcoreapp3.1\win-x64\OmniSharpHack.exe'

" Use the stdio OmniSharp-roslyn server
let g:OmniSharp_server_stdio = 1

" Set the type lookup function to use the preview window instead of echoing it
"let g:OmniSharp_typeLookupInPreview = 1

" Timeout in seconds to wait for a response from the server
let g:OmniSharp_timeout = 5

" Don't autoselect first omnicomplete option, show options even if there is only
" one (so the preview documentation is accessible). Remove 'preview' if you
" don't want to see any documentation whatsoever.
set completeopt=longest,menuone,preview

" Fetch full documentation during omnicomplete requests.
" By default, only Type/Method signatures are fetched. Full documentation can
" still be fetched when you need it with the :OmniSharpDocumentation command.
"let g:omnicomplete_fetch_full_documentation = 1

" Set desired preview window height for viewing documentation.
" You might also want to look at the echodoc plugin.
set previewheight=5

" Tell ALE to use OmniSharp for linting C# files, and no other linters.
let g:ale_linters = { 'cs': ['OmniSharp'] }

" Update semantic highlighting on BufEnter and InsertLeave
let g:OmniSharp_highlight_types = 2

augroup omnisharp_commands
    autocmd!

    " Show type information automatically when the cursor stops moving
    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

    " The following commands are contextual, based on the cursor position.
    autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>

    " Finds members in the current buffer
    autocmd FileType cs nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>

    autocmd FileType cs nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>tt :OmniSharpTypeLookup<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>
    autocmd FileType cs nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
    autocmd FileType cs inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>

    " Navigate up and down by method/property/field
    autocmd FileType cs nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
    autocmd FileType cs nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>

    " Find all code errors/warnings for the current solution and populate the quickfix window
    autocmd FileType cs nnoremap <buffer> <Leader>cc :OmniSharpGlobalCodeCheck<CR>
augroup END

" Contextual code actions (uses fzf, CtrlP or unite.vim when available)
nnoremap <Leader><Space> :OmniSharpGetCodeActions<CR>
" Run code actions with text selected in visual mode to extract method
xnoremap <Leader><Space> :call OmniSharp#GetCodeActions('visual')<CR>

" Rename with dialog
nnoremap <Leader>nm :OmniSharpRename<CR>
nnoremap <F2> :OmniSharpRename<CR>
" Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

nnoremap <Leader>cf :OmniSharpCodeFormat<CR>

" Start the omnisharp server for the current solution
nnoremap <Leader>ss :OmniSharpStartServer<CR>
nnoremap <Leader>sp :OmniSharpStopServer<CR>

" Enable snippet completion
" let g:OmniSharp_want_snippet=1

set updatetime=500

sign define OmniSharpCodeActions text=💡

augroup OSCountCodeActions
  autocmd!
  autocmd FileType cs set signcolumn=yes
  autocmd CursorHold *.cs call OSCountCodeActions()
augroup END

function! OSCountCodeActions() abort
  if bufname('%') ==# '' || OmniSharp#FugitiveCheck() | return | endif
  if !OmniSharp#IsServerRunning() | return | endif
  let opts = {
  \ 'CallbackCount': function('s:CBReturnCount'),
  \ 'CallbackCleanup': {-> execute('sign unplace 99')}
  \}
  call OmniSharp#CountCodeActions(opts)
endfunction

function! s:CBReturnCount(count) abort
  if a:count
    let l = getpos('.')[1]
    let f = expand('%:p')
    execute ':sign place 99 line='.l.' name=OmniSharpCodeActions file='.f
  endif
endfunction
" => OTHER SETTINGS --------------------------------------------------------{{{2
let g:airline_theme = 'codedark'    " use same theme for airline
let g:OmniSharp_server_stdio = 1    " use best communication method to language server

let g:hardtime_default_on = 1
let g:hardtime_showmsg = 1

if executable('ag')         " set default searcher for ack to The Silver Searcher
  let g:ackprg = 'ag --vimgrep'
endif

" CtrlP settings
let g:ctrlp_match_window = 'bottom,order:ttb'   " order match files top bottom
let g:ctrlp_switch_buffer = 0                   " always open in new buffer
let g:ctrlp_working_path_mode = 0               " CtrlP accept changing working dir
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'  " Use AG for search

" Titlecase redefine maps
let g:titlecase_map_keys = 0

" => REMAPS --------------------------------------------------------- {{{1

" Use SharpKey to remap keys (Caps Lock is ESC, Right ALT is CTRL)

let mapleader = "\<Space>"          " leader is space

nnoremap <leader><space> :nohlsearch<CR>                " map space to turn off search highlight
nnoremap <leader>ev :e $MYVIMRC<CR>                     " open vimrc file
nnoremap <leader>rv :execute "source " .  $MYVIMRC<CR>  " source vimrc file
nnoremap <leader>s :mksession<CR>                       " save session

nnoremap <leader>u :GundoToggle<CR>                     " toggle gundo
nnoremap <leader>a :Ack

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

nnoremap ; :

" for windows
noremap <leader>w <C-w><C-w>
nnoremap <C-h> <C-w>h  
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>
" vim:fdm=marker
