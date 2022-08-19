{ lib, config, pkgs, ... }: {
  enable = true;
  wrapperFeatures.gtk = true;

  extraOptions = [ "--unsupported-gpu" ];
  systemdIntegration = true;

  config =
    let useFonts = {
      names = [ "Comic Mono" "Hack" ];
      style = "Normal";
      size = 12.0;
    }; in
  rec {
    bars = [{
      statusCommand = "i3status-rs ~/.config/i3status-rust/config-default.toml";
      fonts = useFonts;
    }];

    focus.newWindow = "urgent";

    fonts = useFonts;
    modifier = "Mod4";
    terminal = "alacritty";

    window.hideEdgeBorders = "smart";

    keybindings = let
      mod = config.wayland.windowManager.sway.config.modifier;
      volcheck = ''if [ `pamixer --get-mute` = "true" ]; then echo 0; else pamixer --get-volume; fi | mosquitto_pub -t wob -l'';
    in lib.mkOptionDefault {
        "XF86MonBrightnessUp" = "exec brightnessctl set +10%";
        "XF86MonBrightnessDown" = "exec brightnessctl set 10%-";

        "XF86AudioPause" = "exec playerctl play-pause";
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";

        "XF86AudioRaiseVolume" = "exec sh -c 'pamixer -u && pamixer -i 5 && ${volcheck}'";
        "XF86AudioLowerVolume" = "exec sh -c 'pamixer -d 5 && ${volcheck}'";
        "XF86AudioMute" = "exec sh -c 'pamixer -t && ${volcheck}'";

        "${mod}+g" = "split h";

        "${mod}+d" = "exec rofi -show drun -modi drun,run";
        "${mod}+Shift+z" = "exec swaylock -c 282828";
        "${mod}+Shift+n" = "exec networkmanager_dmenu";
    };

    floating.criteria = [
      { title = "Firefox — Sharing Indicator"; }
    ];

    assigns = {
      "Firefox is sharing" = [{ title = "Firefox — Sharing Indicator"; }];
    };
  };
}
