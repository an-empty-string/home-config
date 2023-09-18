{ pkgs, ... }:

{
  imports = [
    ./generated.nix
    ../modules/common.nix
  ];

  boot.loader.systemd-boot.enable = true;

  networking.hostName = "beacon";
  time.timeZone = "American/New_York";

  system.stateVersion = "23.05";

  networking.interfaces.eno1.useDHCP = true;
}
