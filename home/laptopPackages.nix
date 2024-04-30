{ pkgs, unstable, ... }:

{
  # qgis
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebkit-5.212.0-alpha4"
  ];

  home.packages = with pkgs; [
    arduino
    audacity
    brightnessctl
    chirp
    chromium
    comic-mono
    darktable
    discord
    docker-compose
    emojione
    unstable.fldigi
    font-awesome_5
    freerdp
    gimp-with-plugins
    gridtracker
    grim
    gqrx
    hack-font
    hugin
    imv
    inkscape
    jd-gui
    unstable.josm
    keepassxc
    libnotify
    networkmanager_dmenu
    noto-fonts-emoji
    obs-studio
    openttd
    openttd-nml
    openvpn
    pamixer
    pavucontrol
    playerctl
    prismlauncher
    slack
    qgis
    qpwgraph
    qsynth
    rofi-wayland
    signal-desktop
    slurp
    speedcrunch
    spotify
    swayidle
    tqsl
    vlc
    volumeicon
    wdisplays
    wego
    wireshark
    wl-clipboard
    wob
    wsjtx
    xdg-desktop-portal-wlr
    zathura

    unstable.android-tools
    unstable.kdenlive
  ];
}
