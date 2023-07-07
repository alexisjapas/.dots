"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GENERAL
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" required
let g:polyglot_disabled = ['markdown']
set nocompatible
filetype off

" mouse integration
set mouse=a

" shell
set shell=/bin/bash
set encoding=utf-8

" fold
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

" visuals
set cursorline
set number relativenumber
syntax on

" split
set splitbelow
set splitright
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" flagging unnecessary whitespace
au BufRead, BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" airline : require noto-fonts-cjk
"let g:airline_theme='simple'

" YouCompleteMe
set completeopt-=preview
highlight Pmenu ctermbg=darkblue

" vimspector
nnoremap <leader>da :call vimspector#Launch()<CR>
nnoremap <leader>dx :call vimspector#Reset()<CR>
nnoremap <S-k> :call vimspector#StepOut()<CR>
nnoremap <S-l> :call vimspector#StepInto()<CR>
nnoremap <S-j> :call vimspector#StepOver()<CR>
nnoremap <leader>d_ :call vimspector#Restart()<CR>
nnoremap <leader>dn :call vimspector#Continue()<CR>
nnoremap <leader>drc :call vimspector#RunToCursor()<CR>
nnoremap <leader>dh :call vimspector#ToggleBreakpoint()<CR>
nnoremap <leader>de :call vimspector#ToggleConditionalBreakpoint()<CR>
nnoremap <leader>dX :call vimspector#ClearBreakpoints()<CR>
let g:vimspector_enable_mappings = 'HUMAN'

" ALE
let g:ale_python_flake8_options = '--max-line-length=88'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PYTHON
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PEP8 indentation
au BufNewFile, BufRead *.py
	\ set tabstop=4
	\ set softtabstop=4
	\ set shiftwidth=4
	\ set textwidth=119
	\ set expandtab
	\ set autoindent
	\ set fileformat=unix

" visuals
let python_highlight_all=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VUNDLE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" add all plugins here
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'sheerun/vim-polyglot'
Plugin 'ycm-core/YouCompleteMe' " require: cmake, openjdk17-src, nodejs, npm, go
Plugin 'puremourning/vimspector'
Plugin 'dense-analysis/ale'  " require: flake8

" all of the plugins must be added before the following line
call vundle#end()
filetype plugin indent on
