{ pkgs, ... }:

{
  imports = [
    ./generated.nix
    ../modules/common.nix
  ];

  # FIXME
  boot.initrd.luks.devices.cryptlvm.device = "/dev/sdaX";

  networking.hostName = "beacon";
  time.timeZone = "American/New_York";

  system.stateVersion = "23.05";

  networking.interfaces.eno1.useDHCP = true;
}
