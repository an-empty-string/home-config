{ options, pkgs, ... }:

if options.graphicalEnvironment.enable then with pkgs; [
    brightnessctl
    comic-mono-font
    discord
    emojione
    feh
    font-awesome_5
    gimp-with-plugins
    hack-font
    networkmanagerapplet
    pavucontrol
    playerctl
    rofi
    sct
    signal-desktop
    spotify
    termite
    volumeicon
] else []
