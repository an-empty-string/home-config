{ lib, pkgs, localCallPackage, config, ... }: {
  systemd.user.services.inhibit-lid-sleep = {
    Unit.Description = "Prevent lid switch from suspending the system";
    Service.ExecStart = "${pkgs.systemd}/bin/systemd-inhibit --what=handle-lid-switch --who=${config.home.username} --why='Running inhibitor service' --mode=block ${pkgs.coreutils}/bin/sleep infinity";
  };

  programs.password-store.enable = true;
  programs.gpg = localCallPackage programs/gpg.nix;
  services.gpg-agent = localCallPackage programs/gpg-agent.nix;
  services.syncthing.enable = true;

  home.packages = localCallPackage ./laptopPackages.nix;

  fonts.fontconfig.enable = true;
  programs.alacritty = localCallPackage programs/alacritty.nix;
  programs.firefox.enable = true;
  programs.i3status-rust = localCallPackage programs/i3status.nix;
  programs.mako.enable = true;
  services.gammastep = localCallPackage programs/gammastep.nix;
  services.mpris-proxy.enable = true;
  wayland.windowManager.sway = localCallPackage programs/sway.nix;

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    SDL_VIDEODRIVER = "wayland";
  };

  home.file.swayidle = let
    swaylock = "swaylock -lfF -c 282828";
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

  systemd.user.services.wob = {
    Unit.Description = "wob overlay bar display";
    Service.ExecStart = "/bin/sh -c 'mosquitto_sub -t wob | wob --background-color \"#262626dd\" --bar-color \"#ebdbb2dd\" --border-color \"#b8bb26dd\" --anchor top --anchor right'";
    Service.Restart = "always";
    Install.WantedBy = [ "sway-session.target" ];
  };

  systemd.user.services.sov = {
    Unit.Description = "sov window overviewer";
    Service.ExecStart = "/bin/sh -c 'mosquitto_sub -t sov | sov'";
    Service.Restart = "always";
    Install.WantedBy = [ "sway-session.target" ];
  };

  systemd.user.services.kanshi.Install.WantedBy = [ "sway-session.target" ];

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
    profiles = {
      undocked = {
        outputs = [{
          criteria = "eDP-1";
          status = "enable";
        }];
      };
      docked = {
        outputs = [{
          criteria = "eDP-1";
          status = "disable";
        } {
          criteria = "DP-7";
          status = "enable";
        } {
          criteria = "DP-8";
          status = "enable";
        }];
      };
      docked2 = {
        outputs = [{
          criteria = "eDP-1";
          status = "disable";
        } {
          criteria = "DP-4";
          status = "enable";
        } {
          criteria = "DP-5";
          status = "enable";
        }];
      };
      docked3 = {
        outputs = [{
          criteria = "eDP-1";
          status = "disable";
        } {
          criteria = "DP-5";
          status = "enable";
        } {
          criteria = "DP-6";
          status = "enable";
        }];
      };
    };
  };
}
