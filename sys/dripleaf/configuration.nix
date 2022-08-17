{ ... }:

{
  imports = [
    ./generated.nix
    ../modules/laptop.nix
  ];

  boot.initrd.luks.devices.cryptlvm.device = "/dev/nvme0n1p1";

  networking.hostName = "dripleaf";
  time.timeZone = "America/Chicago";

  services.hardware.bolt.enable = true;

  services.tlp.settings = {
    START_CHARGE_THRESH_BAT0 = 75;
    STOP_CHARGE_THRESH_BAT0 = 80;
  };

  system.stateVersion = "22.05";
}