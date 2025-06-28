{ lib, pkgs, unstable, config, ... }:

{
  imports = [
    ./generated.nix
    ../modules/laptop.nix
  ];

  boot.initrd.luks.devices.cryptlvm.device = "/dev/nvme0n1p1";
  networking.hostName = "dripleaf";
  time.timeZone = "America/New_York";

  programs.steam.enable = true;
  virtualisation.libvirtd.enable = true;

  services.hardware.bolt.enable = true;

  systemd.services.bluetooth.serviceConfig.ExecStart = lib.mkForce [
    ""
    "${config.hardware.bluetooth.package}/libexec/bluetooth/bluetoothd -f /etc/bluetooth/main.conf -C"
  ];

  services.udev.extraRules = ''
    KERNEL=="rfcomm[1-9]*",ENV{ID_MM_DEVICE_IGNORE}="1"
  '';

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
      tomb
      pinentry
      pinentry-curses
      redir
    ];

  programs.nix-ld.enable = true;

  system.stateVersion = "22.05";
  networking.firewall.allowedTCPPorts = [ 8001 ];
}
