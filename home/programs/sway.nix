{ lib, config, pkgs, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    extraOptions = [ "--unsupported-gpu" ];
    systemd.enable = true;

    config =
      let useFonts = {
        names = [ "Comic Mono" "Hack" ];
        style = "Normal";
        size = 12.0;
      }; in
    rec {
      bars = [];

      focus.newWindow = "urgent";

      fonts = useFonts;
      modifier = "Mod4";
      terminal = "alacritty";

      window.hideEdgeBorders = "smart";

      keybindings = let
        mod = config.wayland.windowManager.sway.config.modifier;
        volcheck = ''if [ `pamixer --get-mute` = "true" ]; then echo 0; else pamixer --get-volume; fi | mosquitto_pub -t wob -l'';
      in lib.mkOptionDefault {
          "XF86MonBrightnessUp" = "exec brightnessctl -e set +10%";
          "XF86MonBrightnessDown" = "exec brightnessctl -e set 10%-";

          "XF86AudioPause" = "exec playerctl play-pause";
          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioPrev" = "exec playerctl previous";

          "XF86AudioRaiseVolume" = "exec sh -c 'pamixer -u && pamixer -i 5 && ${volcheck}'";
          "XF86AudioLowerVolume" = "exec sh -c 'pamixer -d 5 && ${volcheck}'";
          "XF86AudioMute" = "exec sh -c 'pamixer -t && ${volcheck}'";

          "${mod}+comma" = "exec mosquitto_pub -t sov -m 1";
          "--release ${mod}+comma" = "exec mosquitto_pub -t sov -m 0";

          "${mod}+q" = "exec pamixer --default-source -u";
          "--release ${mod}+q" = "exec pamixer --default-source -m";
          "XF86AudioMicMute" = "exec pamixer --default-source -t";

          "${mod}+period" = "exec makoctl dismiss -a";

          "${mod}+g" = "split h";

          "${mod}+d" = "exec rofi -show drun -modi drun,run";
          "${mod}+Shift+z" = "exec swaylock -c 282828";
          "${mod}+Shift+n" = "exec networkmanager_dmenu";
          "${mod}+Shift+x" = "exec alacritty -e sh -c 'q=`mktemp`; wl-paste > $q; vim $q; wl-copy < $q; shred -u $q'";
          "${mod}+Shift+a" = "exec systemctl stop --user waybar";
          "${mod}+Shift+s" = "exec systemctl start --user waybar";
          "${mod}+Shift+c" = "exec bin/clippy copy";
          "${mod}+Shift+v" = "exec bin/clippy dmenu";

          "Ctrl+Alt+Shift+Mod4+L" = "exec xdg-open https://linkedin.com";
      };

      floating.criteria = [
        { title = "Firefox — Sharing Indicator"; }
      ];

      assigns = {
        "Firefox is sharing" = [{ title = "Firefox — Sharing Indicator"; }];
      };
    };
  };
}
