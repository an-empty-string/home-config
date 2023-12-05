{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPython3Packages = (ps: with ps; [
      flask
      black
      isort
    ]);

    extraConfig = ''
      let g:black_use_virtualenv = 0

      set expandtab
      set modeline
      set mouse=a
      set number
      set relativenumber
      set shiftwidth=4
      set tabstop=4

      set nocompatible

      " Set window title
      set title

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

      " Reasonably autoformat
      autocmd BufWritePre *.py :Isort
      autocmd BufWritePre *.py :Black

      " Two space tabs in YAML and nix files
      autocmd FileType yaml setlocal ts=2 sw=2
      autocmd FileType nix setlocal ts=2 sw=2

      " Maps
      nmap <silent> <Leader>h :set nohlsearch<CR>
      nmap <silent> <Leader>af :Black<CR>

      colorscheme gruvbox

      lua << EOF
        require'nvim-treesitter.configs'.setup {
          auto_install = false,
          highlight = {
            enable = true,
          },
        }
      EOF
    '';

    plugins = with pkgs.vimPlugins; let
      tris-vim-black = pkgs.vimUtils.buildVimPlugin {
        name = "vim-black";
        src = pkgs.fetchFromGitHub {
          owner = "psf";
          repo = "black";
          rev = "8aa39b69fca3d78baf841fc4bb2f4202936a67e1";
          hash = "sha256-QJpUCWd3A9J8x36k5iEcqSm4kKIJghOi9K7ICDjiaE0=";
        };
      };
      vim-varnish = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "vim-varnish";
        src = pkgs.fetchFromGitHub {
          owner = "varnishcache-friends";
          repo = "vim-varnish";
          rev = "5f6050c3c215968ac84dc4a48a4968a054390fd1";
          hash = "sha256-nW0dLP2JlbVfIW4WPU8qPVnOdZlc1QoYhyQYFhMPVGQ=";
        };
      };
    in [
      gruvbox
      vim-unimpaired
      vim-airline
      vim-airline-themes
      vim-python-pep8-indent
      vim-nix
      vim-terraform
      vim-varnish

      vimwiki
      nvim-tree-lua

      tris-vim-black
      vim-isort

      (nvim-treesitter.withPlugins (p: with p; [
        nix
        python
        ruby
        html
      ]))
    ];
  };
}
