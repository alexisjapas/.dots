{ config, pkgs, callPackage, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.obergam = {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "23.05";
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
    home.packages = with pkgs; [
      (python3.withPackages (ps: with ps; [
        debugpy
      ]))
      nomacs
      element-desktop
      protonvpn-gui
      neofetch
    ];

    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ vim-airline vim-airline-themes vim-polyglot vimspector YouCompleteMe vim-nix nerdtree ];
      settings = { ignorecase = true; };
      extraConfig = ''
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
        " let g:ale_python_flake8_options = '--max-line-length=88'

        " NERDTree
        nnoremap <leader>n :NERDTreeFocus<CR>
        nnoremap <C-n> :NERDTree<CR>
        nnoremap <C-t> :NERDTreeToggle<CR>
        nnoremap <C-f> :NERDTreeFind<CR>

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
      '';
    };

  };
}
