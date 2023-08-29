{ lib, pkgs, ... }:

{
  imports = [
    ./generated.nix
    ../modules/laptop.nix
  ];

  boot.initrd.luks.devices.cryptlvm.device = "/dev/nvme0n1p1";

  networking.hostName = "dripleaf";
  time.timeZone = "America/New_York";

  services.hardware.bolt.enable = true;

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

  services.open-fprintd.enable = true;
  services.python-validity.enable = true;
  security.pam.services = {
    doas.fprintAuth = true;
    login.fprintAuth = true;
    swaylock.fprintAuth = true;
  };

  hardware.rtl-sdr.enable = true;

  system.stateVersion = "22.05";
}
