{ ... }:

{
  imports = [
    ./generated.nix
    ../modules/laptop.nix
  ];

  boot.initrd.luks.devices.cryptlvm.device = "/dev/sda6";

  networking.hostName = "shulkerbox";
  time.timeZone = "America/Chicago";

  services.tlp.settings = {
    START_CHARGE_THRESH_BAT0 = 55;
    STOP_CHARGE_THRESH_BAT0 = 60;
  };

  system.stateVersion = "21.11";
}
