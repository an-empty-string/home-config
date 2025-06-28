{ ... }:

let
  normalColors = {
    primary.background = "0x1d2021";
    primary.foreground = "0xfbf1c7";
    cursor.text = "0x282828";
    cursor.cursor = "0xd5c4a1";
    normal = {
      black = "0x928374";
      red = "0xfb4934";
      green = "0xb8bb26";
      yellow = "0xfabd2f";
      blue = "0x83a598";
      magenta = "0xd3869b";
      cyan = "0x8ec07c";
      white = "0xd5c4a1";
    };

    bright = {
      black = "0x665c54";
      red = "0xfb4934";
      green = "0xb8bb26";
      yellow = "0xfabd2f";
      blue = "0x83a598";
      magenta = "0xd3869b";
      cyan = "0x8ec07c";
      white = "0xfbf1c7";
    };

    indexed_colors = [
      { index = 16; color = "0xfe8019"; }
      { index = 17; color = "0xd65d0e"; }
      { index = 18; color = "0x3c3836"; }
      { index = 19; color = "0x504945"; }
      { index = 20; color = "0xbdae93"; }
      { index = 21; color = "0xebdbb2"; }
    ];
  };
  lightColors = {
    primary.background = "0xf9f5d7";
    primary.foreground = "0x282828";
    cursor.text = "0xfbf1c7";
    cursor.cursor = "0x504945";
    normal = {
      red = "0x9d0006";
      green = "0x79740e";
      yellow = "0xb57614";
      blue = "0x076678";
      magenta = "0x8f3f71";
      cyan = "0x427b58";

      # black = "0xfbf1c7";
      # white = "0x3c3836";

      white = "0xfbf1c7";
      black = "0x3c3836";
    };
    bright = {
      red = "0xcc241d";
      green = "0x98971a";
      yellow = "0xd79921";
      blue = "0x488588";
      magenta = "0xb16286";
      cyan = "0x689d6a";

      # black = "0xf9f5f7";
      # white = "0x282828";
      white = "0xf9f5f7";
      black = "0x282828";
    };
    indexed_colors = [
      { index = 16; color = "0xaf3a03"; }
      { index = 17; color = "0xd65d0e"; }
      { index = 18; color = "0xebdbb2"; }
      { index = 19; color = "0xd5c4a1"; }
      { index = 20; color = "0x665c54"; }
      { index = 21; color = "0x3c3836"; }
    ];
  };
  grayscaleColors = {
    primary.background = "0x282828";
    primary.foreground = "0xdbdbdb";
    cursor.text = "0x282828";
    cursor.cursor = "0xc5c5c5";
    normal = {
      black = "0x858585";
      red = "0x7b7b7b";
      green = "0xa9a9a9";
      yellow = "0xbfbfbf";
      blue = "0x999999";
      magenta = "0x9f9f9f";
      cyan = "0xa9a9a9";
      white = "0xc5c5c5";
    };

    bright = {
      black = "0x5e5e5e";
      red = "0x7b7b7b";
      green = "0xa9a9a9";
      yellow = "0xbfbfbf";
      blue = "0x999999";
      magenta = "0x9f9f9f";
      cyan = "0xa9a9a9";
      white = "0xefefef";
    };

    indexed_colors = [
      { index = 16; color = "0x999999"; }
      { index = 17; color = "0x787878"; }
      { index = 18; color = "0x383838"; }
      { index = 19; color = "0x4a4a4a"; }
      { index = 20; color = "0xafafaf"; }
      { index = 21; color = "0xdbdbdb"; }
    ];
  };
in
  {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
      };
      font = {
        normal.family = "Comic Mono";
        size = 15;
      };
      colors = lightColors;
      cursor = {
        style.shape = "block";
        vi_mode_style.shape = "underline";
      };
      keyboard.bindings = [
        { key = "V"; mods = "Shift|Control"; action = "Paste"; }
        { key = "C"; mods = "Shift|Control"; action = "Copy"; }
        { key = "Minus"; mods = "Control"; action = "DecreaseFontSize"; }
        { key = "Equals"; mods = "Control"; action = "IncreaseFontSize"; }
      ];
    };
  };
}
