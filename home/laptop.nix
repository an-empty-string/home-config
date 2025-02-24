{ lib, pkgs, localCallPackage, config, ... }: {
  imports = [
    ./laptopPackages.nix
    programs/gpg.nix
    programs/gpg-agent.nix
    programs/alacritty.nix
    programs/gammastep.nix
    programs/sway.nix
    programs/waybar.nix
  ];

  systemd.user.services.inhibit-lid-sleep = {
    Unit.Description = "Prevent lid switch from suspending the system";
    Service.ExecStart = "${pkgs.systemd}/bin/systemd-inhibit --what=handle-lid-switch --who=${config.home.username} --why='Running inhibitor service' --mode=block ${pkgs.coreutils}/bin/sleep infinity";
  };

  programs.password-store.enable = true;
  # services.syncthing.enable = true;

  fonts.fontconfig.enable = true;
  programs.firefox.enable = true;
  services.mako.enable = true;
  services.mako.extraConfig = ''
    [mode=dnd]
    invisible=1
  '';
  services.mpris-proxy.enable = true;
  services.pass-secret-service.enable = true;

  home.file.clippy = {
    source = files/clippy;
    target = "bin/clippy";
    executable = true;
  };

  home.file.detached-term = {
    source = files/detached-term;
    target = "bin/dterm";
    executable = true;
  };

  gtk.enable = true;
  gtk.iconTheme = {
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
  };

  home.file.swayidle = let
    swaylock = "${pkgs.swaylock}/bin/swaylock -lfF -c 282828";
    displayOff = pkgs.writeShellScript "displayOff" ''
      if [ -e /sys/class/power_supply/AC/online ] && [ "$(cat /sys/class/power_supply/AC/online)" = "1" ]; then
        exit 0
      fi

      swaymsg "output * dpms off"
    '';
  in {
    text = ''
      timeout 120 '${displayOff}' resume 'swaymsg "output * dpms on"'

      timeout 300 '${swaylock}'
      before-sleep '${swaylock}'
    '';
    target = ".config/swayidle/config";
  };

  systemd.user.services.swayidle = {
    Unit.Description = "swayidle idle management daemon";
    Service.ExecStart = "${pkgs.swayidle}/bin/swayidle -w";
    Service.Restart = "always";
    Install.WantedBy = [ "sway-session.target" ];
  };

  home.file.wob-volume-config = {
    text = ''
      background_color = 262626dd
      border_color = b8bb26dd
      bar_color = ebdbb2dd
      anchor = top right
    '';

    target = ".config/wob/volume";
  };

  systemd.user.services.wob = {
    Unit.Description = "wob overlay bar display";
    Service.ExecStart = "/bin/sh -c '${pkgs.mosquitto}/bin/mosquitto_sub -t wob | ${pkgs.wob}/bin/wob -c ~/.config/wob/volume'";
    Service.Restart = "always";
    Install.WantedBy = [ "sway-session.target" ];
  };

  home.file.keyd-to-mqtt = {
    source = files/keyd-to-mqtt;
    target = "bin/keyd-to-mqtt";
    executable = true;
  };

  systemd.user.services.mqtt-keyd = {
    Unit.Description = "MQTT to keyd bridge";
    Unit.StartLimitIntervalSec = "0";
    Service = {
      ExecStart = "/home/tris/.nix-profile/bin/python3 /home/tris/bin/keyd-to-mqtt";
      Restart = "always";
      RestartSec = "10";
    };
    Install.WantedBy = [ "sway-session.target" ];
  };

  systemd.user.services.kanshi.Install.WantedBy = [ "sway-session.target" ];

  systemd.user.services.mqtt-bluetooth = {
    Unit.Description = "MQTT to bluetoothctl bridge";
    Unit.StartLimitIntervalSec = "0";
    Service = {
      ExecStart = "${pkgs.tris-mqtt-bluetooth}/bin/mqtt-bluetooth";
      Restart = "always";
      RestartSec = "30";
      Environment = "PATH=${pkgs.bluez}/bin";
    };
  };

  home.file.electron-flags = {
    text = ''
      --enable-features=UseOzonePlatform
      --ozone-platform=wayland
    '';
    target = ".config/electron-flags.conf";
  };

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

  services.kanshi = {
    enable = true;
    settings = [
      {
        profile = {
          name = "undocked";
          outputs = [{
            criteria = "eDP-1";
            status = "enable";
          }];
        };
      }
      {
        profile = {
          name = "docked";
          outputs = [{
            criteria = "eDP-1";
            status = "disable";
          } {
            criteria = "DP-4";
            status = "enable";
            mode = "2560x1440";
            position = "0,0";
            transform = "270";
          } {
            criteria = "DP-5";
            status = "enable";
            mode = "2560x1440";
            position = "1440,560";
            transform = "normal";
          }];
        };
      }
      {
        profile = {
          name = "docked2";
          outputs = [{
            criteria = "eDP-1";
            status = "disable";
          } {
            criteria = "DP-6";
            status = "enable";
            mode = "2560x1440";
            position = "0,0";
            transform = "270";
          } {
            criteria = "DP-7";
            status = "enable";
            mode = "2560x1440";
            position = "1440,560";
            transform = "normal";
          }];
        };
      }
    ];
  };
}
