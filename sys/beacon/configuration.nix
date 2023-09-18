{ pkgs, ... }:

{
  imports = [
    ./generated.nix
    ../modules/common.nix
  ];

  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "beacon";
  time.timeZone = "American/New_York";

  system.stateVersion = "23.05";

  networking.interfaces.eno1.useDHCP = true;
}
