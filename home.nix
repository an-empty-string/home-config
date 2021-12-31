{ lib, config, pkgs, ... }:

let
  localCallPackage = path: ((import path) { inherit lib options pkgs; } );
  options = localCallPackage ./local.nix;
in lib.mkMerge [
  {
    home.username = options.username;
    home.homeDirectory = options.homeDirectory;
    home.stateVersion = "21.05";

    home.sessionVariables = lib.mkMerge [
      {
        EDITOR = "vim";
      }
      (lib.mkIf (!options.isNixOS) {
        NIX_PATH = "$HOME/.nix-defexpr/channels\${NIX_PATH:+:}$NIX_PATH";
      })
    ];

    nixpkgs.overlays = [ (import ./overlay) ];

    home.packages = with pkgs; [
      ag
      aspell
      aspellDicts.en
      bind        # dig
      inetutils   # traceroute
      mosh
      nmap
      openssl
      picocom
      sipcalc
      sshfs
      tris-upload-utils
    ];

    programs.home-manager.enable = true;

    programs.vim = localCallPackage home/programs/vim.nix;
    programs.zsh = localCallPackage home/programs/zsh.nix;
    programs.ssh = localCallPackage home/programs/ssh.nix;
    programs.git = localCallPackage home/programs/git.nix;
    programs.tmux = localCallPackage home/programs/tmux.nix;

    programs.gpg = localCallPackage home/programs/gpg.nix;
    services.gpg-agent = localCallPackage home/programs/gpg-agent.nix;
  }

  (lib.mkIf options.isNixOSUnstable {
    home.file.nixconf = {
      text = ''
        experimental-features = nix-command flakes
      '';

      target = ".config/nix/nix.conf";
    };
  })

  (lib.mkIf options.developmentEnvironment.enable {
    home.packages = with pkgs; [
      direnv
      niv
      nix-prefetch
    ];

    services.lorri.enable = true;
  })

  (lib.mkIf options.graphicalEnvironment.enable (lib.mkMerge [
    {
      home.packages = localCallPackage home/package-sets/graphicalEnvironment.nix;

      fonts.fontconfig.enable = true;

      xsession.enable = true;
      xsession.windowManager.i3 = localCallPackage home/programs/i3.nix;

      programs.firefox.enable = true;

      programs.termite = localCallPackage home/programs/termite.nix;
      programs.i3status-rust = localCallPackage home/programs/i3status.nix;

      services.dunst.enable = true;
      services.redshift = localCallPackage home/programs/redshift.nix;

      home.file.volumeicon = {
        target = ".config/volumeicon/volumeicon";
        source = home/files/volumeicon.conf;
      };
    }

    (lib.mkIf options.graphicalEnvironment.useXScreensaver {
      services.xscreensaver = {
        enable = true;
        settings = {
          fade = false;
          lock = true;
        };
      };

      systemd.user.services.xscreensaver.Service.Environment = "PATH=%h/.nix-profile/bin";
    })
  ]))

  (lib.mkIf options.python.enable {
    home.packages = [
      (
        options.python.package.withPackages (p: with p; [
          requests
          ipython
        ] ++ (options.python.additionalPythonPackages p))
      )
    ];
  })

  options.additionalConfig
]
