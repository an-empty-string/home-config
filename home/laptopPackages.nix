{ pkgs, unstable, dsd-fme, ... }:

{
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebkit-5.212.0-alpha4" # qgis
    "electron-27.3.11" # logseq
  ];

  home.packages = with pkgs; [
    arduino
    audacity
    bat
    brightnessctl
    chirp
    chromium
    comic-mono
    darktable
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
    keepassxc
    libnotify
    logseq
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
    zoom-us

    unstable.android-tools
    unstable.josm
    unstable.kdenlive
  ];
}
