{ options, lib, ... }: {
  enable = true;
  wrapperFeatures.gtk = true;

  extraOptions = [ "--unsupported-gpu" ];

  config =
    let fonts = {
      names = [ "Comic Mono" "Hack" ];
      style = "Normal";
      size = 12.0;
    }; in
  {
    bars = [{
      statusCommand = "i3status-rs ~/.config/i3status-rust/config-default.toml";
      fonts = fonts;
    }];

    focus.newWindow = "urgent";

    fonts = fonts;
    modifier = options.graphicalEnvironment.i3Modifier;
    terminal = "alacritty";

    window.hideEdgeBorders = "smart";

    keybindings =
      let mod = options.graphicalEnvironment.i3Modifier; in
    lib.mkOptionDefault {
        "XF86MonBrightnessUp" = "exec brightnessctl set +10%";
        "XF86MonBrightnessDown" = "exec brightnessctl set 10%-";

        "XF86AudioPause" = "exec playerctl play-pause";
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";

        "XF86AudioRaiseVolume" = "exec pamixer -i 5";
        "XF86AudioLowerVolume" = "exec pamixer -d 5";

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

    startup = [
      { command = "systemctl --user restart swayidle.service"; always = true; }
    ];
  };
}
