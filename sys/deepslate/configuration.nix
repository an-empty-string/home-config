{ ... }:

{
  imports = [
    ./generated.nix
    ../modules/laptop.nix
  ];

  boot.initrd.luks.devices.cryptlvm.device = "/dev/nvme0n1p5";

  networking.hostName = "deepslate";
  time.timeZone = "America/Chicago";

  virtualisation.docker.enable = true;

  services.hardware.bolt.enable = true;

  services.tlp.settings = {
    START_CHARGE_THRESH_BAT0 = 75;
    STOP_CHARGE_THRESH_BAT0 = 80;
  };

  system.stateVersion = "21.11";
}
