{ pkgs, unstable, dsd-fme, ... }:

{
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebkit-5.212.0-alpha4" # qgis
    "electron-27.3.11" # logseq
  ];

  home.packages = with pkgs; [
    audacity
    bat
    brightnessctl
    calibre
    cairo
    chirp
    chromium
    comic-mono
    darktable
    docker-compose
    emojione
    font-awesome_5
    freerdp
    gimp-with-plugins
    grim
    hack-font
    imv
    inkscape
    keepassxc
    libnotify
    logseq
    networkmanager_dmenu
    noto-fonts-emoji
    obs-studio
    pamixer
    pavucontrol
    playerctl
    prismlauncher
    slack
    qgis
    rofi-wayland
    signal-desktop
    slurp
    speedcrunch
    spotify
    swayidle
    vlc
    volumeicon
    wdisplays
    wego
    wireshark
    wl-clipboard
    wob
    xdg-desktop-portal-wlr
    zathura
    zoom-us

    unstable.android-tools
    unstable.josm
  ];
}
