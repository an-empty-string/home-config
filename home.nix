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
      asciinema
      aspell
      aspellDicts.en
      bind        # dig
      fzf
      htop
      inetutils   # traceroute
      jq
      mosh
      nmap
      openssl
      picocom
      pwgen
      sipcalc
      sshfs
      step-cli
      unzip
    ];

    programs.home-manager.enable = true;

    programs.vim = localCallPackage home/programs/vim.nix;
    programs.zsh = localCallPackage home/programs/zsh.nix;
    programs.ssh = localCallPackage home/programs/ssh.nix;
    programs.git = localCallPackage home/programs/git.nix;
    programs.tmux = localCallPackage home/programs/tmux.nix;

    programs.gpg = localCallPackage home/programs/gpg.nix;
    services.gpg-agent = localCallPackage home/programs/gpg-agent.nix;

    programs.gitui.enable = true;
    programs.password-store.enable = true;

    systemd.user.services.inhibit-lid-sleep = {
      Unit.Description = "Prevent lid switch from suspending the system";
      Service.ExecStart = "${pkgs.systemd}/bin/systemd-inhibit --what=handle-lid-switch --who=${options.username} --why='Running inhibitor service' --mode=block ${pkgs.coreutils}/bin/sleep infinity";
    };
  }

  (lib.mkIf options.productivityTools.enable (
    localCallPackage home/package-sets/productivityTools.nix
  ))

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

      services.pasystray.enable = true;
      systemd.user.services.pasystray.Service.ExecStart = lib.mkForce "${pkgs.pasystray}/bin/pasystray --notify=all";

      services.mpris-proxy.enable = true;
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
          arrow
          black
          cryptography
          flake8
          ipython
          mypy
          pytest
          requests
        ] ++ (options.python.additionalPythonPackages p))
      )
    ];
  })

  options.additionalConfig
]
