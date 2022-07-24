{ ... }:

{
  imports = [
    ./generated.nix
    ../modules/laptop.nix
  ];

  boot.initrd.luks.devices.cryptlvm.device = "/dev/sda1";

  networking.hostName = "terracotta";
  time.timeZone = "America/Chicago";

  services.tlp.settings = {
    START_CHARGE_THRESH_BAT0 = 75;
    STOP_CHARGE_THRESH_BAT0 = 80;

    START_CHARGE_THRESH_BAT1 = 75;
    STOP_CHARGE_THRESH_BAT1 = 80;
  };

  system.stateVersion = "21.11";
}
