{ pkgs, unstable, ... }:

{
  # qgis
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebkit-5.212.0-alpha4"
  ];

  home.packages = with pkgs; [
    audacity
    authy
    brightnessctl
    calibre
    chromium
    comic-mono
    darktable
    discord
    docker-compose
    emojione
    font-awesome_5
    freerdp
    gimp-with-plugins
    grim
    gqrx
    hack-font
    imv
    inkscape
    unstable.josm
    keepassxc
    kristall
    libnotify
    libreoffice
    # unstable.musescore
    networkmanager_dmenu
    noto-fonts-emoji
    obs-studio
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
    virt-manager
    vlc
    volumeicon
    wdisplays
    wego
    wireshark
    wl-clipboard
    wob
    xdg-desktop-portal-wlr
    zathura

    unstable.android-tools
  ];
}
