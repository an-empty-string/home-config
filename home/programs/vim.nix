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
    nmap <silent> <leader>tf :Pytest file<CR>

    colorscheme gruvbox
  '';

  plugins = with pkgs.vimPlugins; [
    gruvbox
    vimwiki

    vim-unimpaired

    vim-airline
    vim-airline-themes

    vim-python-pep8-indent

    vim-terraform

    (pkgs.vimUtils.buildVimPlugin {
      name = "black";
      src = pkgs.fetchFromGitHub {
        owner = "psf";
        repo = "black";
        rev = "d038a24ca200da9dacc1dcb05090c9e5b45b7869";
        hash = "sha256-n/vwkN6ebgKPze8O4GWyk3NLKyXcvSJqcsf/0mBuLuE=";
      };
    })

    (pkgs.vimUtils.buildVimPlugin {
      name = "pytest";
      src = pkgs.fetchFromGitHub {
        owner = "alfredodeza";
        repo = "pytest.vim";
        rev = "e7ea3599803cb60861c27ac93f6e00cfe3e54826";
        hash = "sha256-2I0pdahQIs0q0Gnrn8D5hH0p07qH8t896wq7zh0bF4Y=";
      };
    })
  ];
}
