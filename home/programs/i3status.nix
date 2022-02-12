{ ... }:

{
  enable = true;

  bars.default = {
    blocks = [
      { block = "music"; buttons = ["play" "next"]; }
      { block = "battery"; format = "{percentage} {time}"; device = "BAT0"; }
      { block = "time"; format = "%Y-%m-%d %H:%M"; }
    ];

    theme = "gruvbox-dark";
    icons = "awesome5";
  };
}
