{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    coc = {
      enable = true;
      pluginConfig = ''
      '';

      settings = {
        python = {
          formatting.provider = "black";

          linting = {
            flake8Enabled = true;
            mypyEnabled = true;
          };
        };
      };
    };

    extraPython3Packages = (ps: with ps; [
      black
    ]);

    extraConfig = ''
      let g:coc_global_extensions = ['coc-pyright', 'coc-yaml']

      set expandtab
      set modeline
      set mouse=a
      set number
      set relativenumber
      set shiftwidth=4
      set tabstop=4

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
      nmap <silent> <Leader>h :set nohlsearch<CR>
      nmap <silent> <Leader>tf :Pytest file<CR>
      nmap <silent> <Leader>af :call CocAction('format')<CR>

      colorscheme gruvbox
    '';

    plugins = with pkgs.vimPlugins; [
      gruvbox
      vim-unimpaired
      vim-airline
      vim-airline-themes
      vim-python-pep8-indent
      vim-nix
    ];
  };
}
