{ ... }:

{
  imports = [
    ./generated.nix
    ../modules/laptop.nix
  ];

  boot.initrd.luks.devices.cryptlvm.device = "/dev/nvme0n1p5";

  virtualisation.libvirtd.enable = true;

  networking.hostName = "deepslate";
  time.timeZone = "America/Chicago";

  services.hardware.bolt.enable = true;

  services.instanced-tailscale.lessbroken = {
    port = 41642;
    interfaceName = "ts-lessbroken";
  };

  services.tlp.settings = {
    START_CHARGE_THRESH_BAT0 = 75;
    STOP_CHARGE_THRESH_BAT0 = 80;
  };

  system.stateVersion = "21.11";
}
