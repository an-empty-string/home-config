{ pkgs, unstable, ... }:

{
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
    musescore
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
