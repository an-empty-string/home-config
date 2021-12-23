{ pkgs, ... }:

{
  enable = true;

  settings = {
    background = "dark";
    expandtab = true;
    modeline = true;
    mouse = "a";
    number = true;
    relativenumber = true;
    shiftwidth = 4;
    tabstop = 4;
  };

  extraConfig = ''
    set nocompatible

    " Tab to cycle through menu options
    set wildmenu

    " Don't wrap
    set nowrap

    " Show matching bracket when closing bracket typed
    set showmatch

    " Don't security bad
    set secure

    " F2 to :set paste!
    set pastetoggle=<F2>

    " Split down and to the right
    set splitbelow
    set splitright

    " Persist undo between sessions
    set undodir=~/.vim/undo
    set undolevels=200

    " Fold with markers
    set foldmethod=marker
    set foldlevel=1

    " Autoindent
    set autoindent

    " Search options
    set hlsearch
    set incsearch
    set smartcase

    " Misc display options
    set cursorcolumn
    set ruler
    set scrolloff=5
    set laststatus=2
    set list
    set listchars=tab:>.,trail:.,extends:#,precedes:#,nbsp:.

    " Disable relativenumber when leaving normal mode
    autocmd InsertEnter * :set norelativenumber
    autocmd InsertLeave * :set relativenumber

    " Two space tabs in YAML and nix files
    autocmd FileType yaml setlocal ts=2 sw=2
    autocmd FileType nix setlocal ts=2 sw=2

    " Maps
    nmap <silent> <leader>h :set nohlsearch<CR>
    nmap <silent> <leader>sv :source ~/.vimrc<CR>

    colorscheme gruvbox
  '';

  plugins = [
    pkgs.vimPlugins.gruvbox
    pkgs.vimPlugins.vim-unimpaired

    pkgs.vimPlugins.vim-airline
    pkgs.vimPlugins.vim-airline-themes

    pkgs.vimPlugins.vim-python-pep8-indent
  ];
}
