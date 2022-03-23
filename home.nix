{lib, config, pkgs, ... }:

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
        MOZ_ENABLE_WAYLAND = "1";
        SDL_VIDEODRIVER = "wayland";
      }
      (lib.mkIf (!options.isNixOS) {
        NIX_PATH = "$HOME/.nix-defexpr/channels\${NIX_PATH:+:}$NIX_PATH";
      })
    ];

    nixpkgs.overlays = [
      (import ./overlay)
    ];

    home.packages = with pkgs; [
      acpi
      asciinema
      aspell
      aspellDicts.en
      awscli2
      bind        # dig
      clang
      ffmpeg
      fzf
      htop
      inetutils   # traceroute
      jq
      mosh
      mosquitto
      nmap
      nodejs
      nodePackages.npm
      openssl
      picocom
      podman
      podman-compose
      pwgen
      rmapi
      ruby
      rustup
      silver-searcher
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

    programs.password-store.enable = true;

    systemd.user.services.inhibit-lid-sleep = {
      Unit.Description = "Prevent lid switch from suspending the system";
      Service.ExecStart = "${pkgs.systemd}/bin/systemd-inhibit --what=handle-lid-switch --who=${options.username} --why='Running inhibitor service' --mode=block ${pkgs.coreutils}/bin/sleep infinity";
    };

    programs.autojump = {
      enable = true;
      enableZshIntegration = true;
    };

    home.file.container-registries = {
      text = ''
        unqualified-search-registries = ['docker.io']
      '';

      target = ".config/containers/registries.conf";
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
      programs.alacritty = localCallPackage home/programs/alacritty.nix;
      programs.firefox.enable = true;
      programs.i3status-rust = localCallPackage home/programs/i3status.nix;
      programs.mako.enable = true;
      services.gammastep = localCallPackage home/programs/gammastep.nix;
      services.kanshi = { enable = true; profiles = options.graphicalEnvironment.kanshiProfiles; };
      services.mpris-proxy.enable = true;
      wayland.windowManager.sway = localCallPackage home/programs/sway.nix;
    }

    {
      home.file.swayidle = let swaylock = "swaylock -lfF -c 282828"; in {
        text = ''
          timeout 300 '${swaylock}'
          before-sleep '${swaylock}'
        '';
        target = ".config/swayidle/config";
      };

      systemd.user.services.swayidle = {
        Unit.Description = "swayidle";
        Service.ExecStart = "${pkgs.swayidle}/bin/swayidle -w";
        Service.Restart = "always";
        Install.WantedBy = [ "default.target" ];
      };
    }

    {
      home.file.electron-flags = {
        text = ''
          --enable-features=UseOzonePlatform
          --ozone-platform=wayland
        '';
        target = ".config/electron-flags.conf";
      };
    }

    {
      home.file.networkmanager-dmenu = {
        text = ''
          [dmenu]
          dmenu_command = rofi -d
          wifi_chars = ▂▄▆█

          [dmenu_passphrase]
          obscure = True
        '';

        target = ".config/networkmanager-dmenu/config.ini";
      };
    }

  ]))

  (lib.mkIf options.python.enable {
    home.packages = [
      (
        options.python.package.withPackages (p: with p; [
          arrow
          black
          cryptography
          flake8
          flask
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
