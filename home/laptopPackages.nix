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
    gajim
    gimp-with-plugins
    grim
    hack-font
    imv
    keepassxc
    lagrange
    libnotify
    libreoffice
    unstable.musescore
    networkmanager_dmenu
    obs-studio
    pamixer
    pavucontrol
    playerctl
    prismlauncher
    # qgis
    qpwgraph
    rofi-wayland
    signal-desktop
    slurp
    speedcrunch
    spotify
    swayidle
    thunderbird
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
