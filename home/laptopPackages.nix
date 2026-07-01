{ pkgs, unstable, dsd-fme, ... }:

{
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebkit-5.212.0-alpha4" # qgis
    "electron-39.8.10" # logseq
  ];

  home.packages = with pkgs; [
    anki
    audacity
    bat
    brightnessctl
    calibre
    cairo
    chirp
    chromium
    claude-code
    comic-mono
    darktable
    docker-compose
    element-desktop
    font-awesome_5
    freerdp
    gam
    gimp-with-plugins
    grim
    hack-font
    imv
    inkscape
    keepassxc
    libnotify
    logseq
    networkmanager_dmenu
    obs-studio
    opencode
    pamixer
    pavucontrol
    playerctl
    prismlauncher
    slack
    qgis
    rofi
    signal-desktop
    slurp
    speedcrunch
    spotify
    swayidle
    thunderbird
    tigervnc
    virt-manager
    vlc
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
