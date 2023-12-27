{ pkgs, ... }:

{
  imports = [
    ./generated.nix
    ../modules/common.nix
  ];

  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
