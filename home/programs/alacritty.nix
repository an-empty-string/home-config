{ ... }:

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
      colors = {
        primary.background = "0x282828";
        primary.foreground = "0xebdbb2";
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
