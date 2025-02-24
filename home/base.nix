{ ... }: {
  imports = [
    ./basePackages.nix
    programs/atuin.nix
    programs/neovim.nix
    programs/zsh.nix
    programs/ssh.nix
    programs/git.nix
    programs/tmux.nix
    programs/autojump.nix
  ];

  home = {
    username = "tris";
    homeDirectory = "/home/tris";
    stateVersion = "21.11";
    sessionVariables = {
      EDITOR = "vim";
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      SDL_VIDEODRIVER = "wayland";
      TPM2TOOLS_TCTI = "tabrmd:bus_type=system";
      TSS2_LOG = "fapi+NONE";
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ (import ../overlay) ];

  home.file.nixconf = {
    text = ''
      experimental-features = nix-command flakes
    '';

    target = ".config/nix/nix.conf";
    };

  programs.home-manager.enable = true;
  services.lorri.enable = true;

  programs.gh.enable = true;  # GitHub CLI
}
