{ localCallPackage, ... }: {
  home.sessionVariables = {
    EDITOR = "vim";
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ (import ../overlay) ];

  home.file.nixconf = {
    text = ''
      experimental-features = nix-command flakes
    '';

    target = ".config/nix/nix.conf";
    };

  home.packages = (localCallPackage ./basePackages.nix);

  programs.home-manager.enable = true;

  programs.vim = localCallPackage programs/vim.nix;
  programs.zsh = localCallPackage programs/zsh.nix;
  programs.ssh = localCallPackage programs/ssh.nix;
  programs.git = localCallPackage programs/git.nix;
  programs.tmux = localCallPackage programs/tmux.nix;

  programs.autojump = localCallPackage programs/autojump.nix;

  services.lorri.enable = true;
}
