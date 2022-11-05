set number         " set line numbers
set autoindent     " indent new line the same amount as the line just typed
set tabstop=4      " number of columns occupied by a tab character
set expandtab      " convert tabs to white space
set shiftwidth=4   " width for autoindents
set softtabstop=4  " see multiple spaces as tabstops so <BS> does the right thing
retab 4            " change tabs to 4 for new files
set showmatch      " show matching brackets
set nowrap         " always nowrap long lines
set guioptions+=b  " set horizontal scrollbar
syntax on
set background=dark


call plug#begin('~/vimfiles/plugged')

Plug 'morhetz/gruvbox'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }


call plug#end()

colorscheme gruvbox

" use jj to Escape to normal mode
inoremap jk <ESC>

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
