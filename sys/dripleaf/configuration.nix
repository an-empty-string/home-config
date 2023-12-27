{ lib, pkgs, ... }:

{
  imports = [
    ./generated.nix
    ../modules/laptop.nix
  ];

  boot.initrd.luks.devices.cryptlvm.device = "/dev/nvme0n1p1";

  networking.hostName = "dripleaf";
  time.timeZone = "America/New_York";

  programs.steam.enable = true;

  services.hardware.bolt.enable = true;

  services.amethyst = {
    enable = true;
    hosts = [
      {
        name = "localhost";
        tls.auto = true;
        paths."/" = {
          root = "/var/gemini";
          cgi = true;
        };
      }
    ];
  };

  services.instanced-tailscale.lessbroken = {
    port = 41642;
    interfaceName = "ts-lessbroken";
  };

  services.tlp.settings = {
    START_CHARGE_THRESH_BAT0 = 75;
    STOP_CHARGE_THRESH_BAT0 = 80;
    CPU_ENERGY_PERF_POLICY_ON_AC = lib.mkForce "performance";
    CPU_ENERGY_PERF_POLICY_ON_BAT = lib.mkForce "balance_power";
  };

  hardware.rtl-sdr.enable = true;

  environment.systemPackages =
    with pkgs; [
      ax25-tools
      ax25-apps
      libax25
      direwolf
    ];

  system.stateVersion = "22.05";
  networking.firewall.allowedTCPPorts = [ 8001 ];
}
