{ options, lib, pkgs, ... }:

{
  enable = true;
  config = {
    modifier = options.graphicalEnvironment.i3Modifier;

    terminal = "termite";

    window = {
      border = 1;
      hideEdgeBorders = "both";
      titlebar = false;
    };

    workspaceAutoBackAndForth = true;

    startup = [
      { command = "nm-applet"; }
      { command = "feh --bg-scale ~/.background.png"; always = true; }
    ];

    keybindings = let modifier = options.graphicalEnvironment.i3Modifier; in lib.mkOptionDefault {
      "XF86MonBrightnessUp" = "exec brightnessctl set +10%";
      "XF86MonBrightnessDown" = "exec brightnessctl set 10%-";

      "XF86AudioPause" = "exec playerctl play-pause";
      "XF86AudioPlay" = "exec playerctl play-pause";
      "XF86AudioNext" = "exec playerctl next";
      "XF86AudioPrev" = "exec playerctl previous";

      "XF86AudioRaiseVolume" = "exec pamixer -i 5";
      "XF86AudioLowerVolume" = "exec pamixer -d 5";

      "${modifier}+grave" = "exec nvidia-settings -a :0/DigitalVibrance=-1024";
      "${modifier}+Shift+grave" = "exec nvidia-settings -a :0/DigitalVibrance=0";

      "${modifier}+d" = "exec \"rofi -modi drun,run -show drun\"";
      "${modifier}+Shift+w" = "exec \"rofi -modi window -show window\"";

      "${modifier}+g" = "split h";

      "${modifier}+h" = "focus left";
      "${modifier}+j" = "focus down";
      "${modifier}+k" = "focus up";
      "${modifier}+l" = "focus right";

      "${modifier}+Shift+h" = "move left";
      "${modifier}+Shift+j" = "move down";
      "${modifier}+Shift+k" = "move up";
      "${modifier}+Shift+l" = "move right";

      "${modifier}+Shift+z" = if options.graphicalEnvironment.useXScreensaver then
        "exec \"xscreensaver-command -lock\""
      else
        "exec \"i3lock\"";

      "${modifier}+Shift+s" = "exec ${pkgs.tris-upload-utils}/bin/upload-helper screenshot";
      "${modifier}+Shift+p" = "exec ${pkgs.tris-upload-utils}/bin/upload-helper pastebin";
    };

    bars = [{
      statusCommand = "i3status-rs ~/.config/i3status-rust/config-default.toml";
      fonts = {
        names = ["Comic Mono" "Hack"];
        style = "Normal";
        size = 12.0;
      };
    }];
  };
}
