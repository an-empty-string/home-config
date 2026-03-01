{ pkgs, ... }:

{
  imports = [
    ./generated.nix
    ../modules/common.nix
    ../modules/graphical.nix
    ../modules/keyd.nix
    ../modules/efiBoot.nix
  ];

  boot.loader.grub.devices = [ "nodev" ];

  services.zigbee2mqtt = {
    enable = true;
    settings = {
      serial.port = "/dev/ttyACM0";
      permit_join = true;
    };
  };

  networking.hostName = "beacon";
  time.timeZone = "American/New_York";

  system.stateVersion = "23.05";

  networking.interfaces.eno1.useDHCP = true;
}
