""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')

" ranger like replacement for NERDtree
"Plug 'airodactyl/neovim-ranger'

" grammar etc. checker?
"Plug 'fmoralesc/nlanguagetool.nvim'

"""""""
" Completion engines
"""""""
"Plug 'roxma/nvim-completion-manager'
"""""""

"Plug 'airblade/vim-gitgutter'

" granular test runner
"Plug 'janko-m/vim-test'

"""""""
" Markdown Composer
"""""""
function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    !cargo build --release
  endif
endfunction
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
"""""""

"""""""
" Airline
"""""""
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"""""""

"Plug 'iCyMind/NeoSolarized'
Plug 'twerth/ir_black'
Plug 'tenable/vim-nasl'
"Plug 'AndrewRadev/linediff.vim'
"Plug 'BenBergman/vsearch.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'jiangmiao/auto-pairs'
Plug 'mbbill/undotree'
Plug 'severin-lemaignan/vim-minimap'
"Plug 'vim-scripts/restore_view.vim'
"Plug 'tpope/vim-fugitive'
"Plug 'majutsushi/tagbar'
"Plug 'google/vim-searchindex'

" Deal with trailing whitespace
"Plug 'ntpeters/vim-better-whitespace'
"map <leader>s :StripWhitespace<CR>

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



augroup AutoCommands
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END


"""""""
" Appearance
"""""""
filetype plugin indent on   " Automatically detect file types.
syntax enable

set background=dark
set termguicolors
"colorscheme NeoSolarized
colorscheme ir_black
set fillchars+=vert:│

let g:airline_powerline_fonts = 1
let g:airline_theme='solarized'

set number
"set cursorline
"""""""


set showcmd
set undofile " Store undos persistently
set undolevels=1000
set undoreload=10000
set scrolloff=3 " Minimum number of lines to keep above and below cursor

set backup                  " Backups are nice ...
" Save temporary/backup files not in the local directory, but in your ~/.vim
" directory, to keep them out of git repos. 
" But first mkdir backup, swap, and undo first to make this work
call system('mkdir ~/.nvim')
call system('mkdir ~/.nvim/backup')
call system('mkdir ~/.nvim/swap')
set backupdir=~/.nvim/backup//
set directory=~/.nvim/swap//

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    call system('mkdir ~/.nvim/undo')
    set undodir=~/.nvim/undo//
    set undofile
    set undolevels=1000
    set undoreload=10000
endif


"imap <C-c> <Esc>


" treat long lines as break lines (useful when moving around in them)
"nnoremap k gk
"nnoremap gk k
"nnoremap j gj
"nnoremap gj j
"nnoremap <up> g<up>
"nnoremap <down> g<down>


set pastetoggle=<F12>



"""""""
" NASL
"""""""
autocmd BufNewFile,BufRead *.audit set syntax=xml
autocmd BufNewFile,BufRead *.nasl set filetype=nasl
autocmd BufNewFile,BufRead *.inc set filetype=nasl
autocmd BufNewFile,BufRead *.inc set indentexpr=
autocmd FileType nasl setlocal shiftwidth=2 tabstop=2 expandtab softtabstop=2 colorcolumn=80
autocmd FileType nasl set commentstring=#\ %s

let g:tagbar_type_nasl = {
        \ 'ctagstype' : 'nasl',
        \ 'kinds'     : [
                \ 'f:functions',
                \ 'v:variables',
                \ 'g:globals',
        \ ]
\ }

let g:syntastic_nasl_checkers = ['nasl_parse', 'nasl']

"map <leader>rv :call VimuxRunCommand("clear; validate-plugin -s -s " . bufname("%"))<CR>

"autocmd FileType nasl map <silent> <leader>ne [(mnV%:s/,\s*\([^$]\)/,\r\1/g'nf(V%:s/(\s*\([^)]\)/(\r\1/'nf(V%:s/\([^(]\)\s*)/\1\r)/'nf(V%='nf(V%:Tabularize /:

"function! DisplayVar(var)
"       call setline(line('.'), substitute(getline('.'), a:var, "display('".a:var.": ', ".a:var.", '".'\\n'."');", 'g'))
"endfunction
"autocmd FileType nasl map <silent> <leader>nd y :call DisplayVar('<C-r>"')<CR>

"function! DisplayVarPretty(var)
"       call setline(line('.'), substitute(getline('.'), a:var, "display('".a:var.": ', pretty(".a:var."), '".'\\n'."');", 'g'))
"endfunction
"autocmd FileType nasl map <silent> <leader>np y :call DisplayVarPretty('<C-r>"')<CR>
"
"autocmd FileType nasl map <silent> <leader>no odisplay(FUNCTION_NAME, ': ', LINE_NUMBER, '\n');
"
"function! MakeTiny(url)
"       let result = system("mktiny " . a:url)
"       let result = substitute(result, '[^a-zA-Z0-9:/.?]', '', 'g')
"       call setline(line('.'), substitute(getline('.'), a:url, result, 'g'))
"endfunction
"vmap mt y :call MakeTiny('<C-r>"')<CR>
"""""""



nnoremap <CR> :noh<CR>

" delete some text, then highlight some other text and hit <C-x>. The two sections will be swapped.
vnoremap <C-x> <Esc>`.``gvP``P

" \ is the new ,
let mapleader = ','
"noremap \ ,

"remove frustration:
noremap Q <Nop>

set wildignorecase "ignore case in filename completion :)
                   "only works for vim 7.3.107 or something

"backspacing removes only one space at a time, not a tab's worth
set softtabstop=0

"stop the cursor from going one past the last char in each line
set ve=""
"stop the cursor from going one past the last char in visual mode
set selection=old

"show all buffers, then select one by typing that number
nnoremap gb :ls<cr>:buffer

"reverse ` and '"
nnoremap ` '
nnoremap ' `

""tab to save
nnoremap <Tab> :w<CR>

""relative and absolute line numbers
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber

" Takes whatever was last searched for and does
" a find and replace for what you type next
" Useful with the * command
noremap <leader>r <Esc>:%s/\(<C-r>/\)//g<left><left>
noremap <leader>R <Esc>:%s/\(<C-r>/\)//gc<left><left><left>"

" Make the word the cursor is on or just after UPPERCASE without leaving
" insert mode using Ctrl b
inoremap <C-b> <Esc>BgUEEi

" make escape instant; get rid of escape delay"
set timeout " Do time out on mappings and others
set timeoutlen=2000 " Wait {num} ms before timing out a mapping
   "when press Esc to leave Ins mode it no longer takes a second
   "or another keystroke to leave Ins mode completely and update
   "the satus line.
set ttimeoutlen=0
augroup FastEscape:
    autocmd!
    au InsertEnter * set timeoutlen=0
    au InsertLeave * set timeoutlen=1000
augroup END

"Set .doctest files to use python syntax highlighting
autocmd BufNewFile,BufRead *.doctest   set syntax=python

""Quickly add a semicolon to the end of the current line;
autocmd FileType nasl noremap <silent> <leader>; mpA;<Esc>`p
autocmd FileType rust noremap <silent> <leader>; mpA;<Esc>`p
autocmd FileType cpp noremap <silent> <leader>; mpA;<Esc>`p

""Scan nasl syntax for highlighting from the top of the file always.
autocmd BufEnter *.nasl :syntax sync fromstart
autocmd BufEnter *.inc :syntax sync fromstart

""Disable spell check in nasl files
autocmd BufEnter *.nasl :set nospell
autocmd BufEnter *.inc :set nospell

""disallow mouse, so I can use it to copy stuff from terminals instead
set mouse=""

if &diff
    set nospell
endif






set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

map <S-H> gT
map <S-L> gt

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$


set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set nowrap
set autoindent                  " Indent at the same level of the previous line
set expandtab


" Change Working Directory to that of the current file
"cmap cwd lcd %:p:h
"cmap cd. lcd %:p:h
set autochdir

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

" Easier horizontal scrolling
map zl zL
map zh zH


nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
let g:vim_json_syntax_conceal = 0


nnoremap <Leader>u :UndotreeToggle<CR>
" If undotree is opened, it is likely one wants to interact with it.
let g:undotree_SetFocusWhenToggle=1

let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1

function! StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
