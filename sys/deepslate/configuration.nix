{ ... }:

{
  imports = [
    ./generated.nix
    ../modules/laptop.nix
    ../modules/pg.nix
  ];

  boot.initrd.luks.devices.cryptlvm.device = "/dev/nvme0n1p5";

  networking.firewall.allowedTCPPorts = [ 9090 ];

  virtualisation.libvirtd.enable = true;

  networking.hostName = "deepslate";
  time.timeZone = "America/Chicago";

  services.flatpak.enable = true;

  services.hardware.bolt.enable = true;

  services.instanced-tailscale.lessbroken = {
    port = 41642;
    interfaceName = "ts-lessbroken";
  };

  services.nix-serve = {
    enable = true;
    secretKeyFile = "/var/cache-priv-key.pem";
  };

  services.tlp.settings = {
    START_CHARGE_THRESH_BAT0 = 45;
    STOP_CHARGE_THRESH_BAT0 = 55;
  };

  system.stateVersion = "21.11";
}
