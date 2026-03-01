{ pkgs, ... }: {
  # Graphical environment
  programs.sway.enable = true;

  services.xserver = {
    # N.B. - doesn't actually run an X server, just sets up graphics drivers
    # enough for us to use Wayland properly
    enable = true;
    videoDrivers = [ "modesetting" ];
    displayManager.startx.enable = true;
  };

  security.pam.services.swaylock = {};

  xdg.portal = {
    enable = true;
    wlr = {
      enable = true;
      settings = {
        screencast = {
          chooser_type = "dmenu";
          chooser_cmd = "${pkgs.rofi}/bin/rofi -dmenu";
        };
      };
    };
  };
}
