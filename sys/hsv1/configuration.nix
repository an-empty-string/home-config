{ pkgs, ... }:

{
  imports = [
    ./generated.nix
    ../modules/common.nix
  ];

  networking.hostName = "hsv1";
  time.timeZone = "Etc/UTC";

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/vda";
  };

  networking.interfaces.enp1s0.useDHCP = true;

  system.stateVersion = "22.05";
}
