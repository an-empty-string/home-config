{ lib, config, pkgs, ... }:

let
  localCallPackage = path: ((import path) { inherit lib options pkgs; } );
  options = localCallPackage ./local.nix;
in lib.mkMerge [
  {
    home.username = options.username;
    home.homeDirectory = options.homeDirectory;
    home.stateVersion = "21.05";
    home.sessionVariables = {
      EDITOR = "vim";
    };

    nixpkgs.overlays = [ (import ./overlay) ];

    home.packages = with pkgs; [
      ag
      bind        # dig
      inetutils   # traceroute
      mosh
      picocom
      sipcalc
    ]
    ++ localCallPackage home/package-sets/python.nix
    ++ localCallPackage home/package-sets/graphicalEnvironment.nix;

    programs.home-manager.enable = true;

    programs.git = {
      enable = true;
      userName = options.displayName;
      userEmail = options.emailAddress;
    };

    home.file.nixconf = {
      text = ''
        experimental-features = nix-command flakes
      '';

      target = ".config/nix/nix.conf";
    };

    programs.vim = localCallPackage home/programs/vim.nix;
    programs.zsh = localCallPackage home/programs/zsh.nix;
  }

  (lib.mkIf options.graphicalEnvironment.enable {
    fonts.fontconfig.enable = true;

    xsession.enable = true;
    xsession.windowManager.i3 = localCallPackage home/programs/i3.nix;

    programs.firefox.enable = true;
    programs.termite = localCallPackage home/programs/termite.nix;
    programs.i3status-rust = localCallPackage home/programs/i3status.nix;

    services.redshift = localCallPackage home/programs/redshift.nix;

    services.xscreensaver = {
      enable = true;
      settings = {
        fade = false;
        lock = true;
      };
    };
    systemd.user.services.xscreensaver.Service.Environment = "PATH=%h/.nix-profile/bin";

    home.file.volumeicon = localCallPackage home/files/volumeicon.nix;
  })

  options.additionalConfig
]
