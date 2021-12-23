{ ... }:

{
  enable = true;

  bars.default = {
    blocks = [
      { block = "music"; player = "spotify"; buttons = ["play" "next"]; }
      { block = "battery"; format = "{percentage} {time}"; }
      { block = "time"; format = "%Y-%m-%d %H:%M"; }
    ];

    theme = "gruvbox-dark";
    icons = "awesome5";
  };
}
