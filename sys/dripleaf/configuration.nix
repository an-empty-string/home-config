{ lib, pkgs, unstable, config, ... }:

{
  imports = [
    ./generated.nix
    ../modules/laptop.nix
  ];

  boot.initrd.luks.devices.cryptlvm.device = "/dev/nvme0n1p1";
  # boot.kernelPatches = [{
  #   name = "ax25-config";
  #   patch = null;
  #   extraConfig = ''
  #     HAMRADIO y
  #     AX25 m
  #     AX25_DAMA_SLAVE y
  #     NETROM m
  #     ROSE m
  #     MKISS m
  #     6PACK m
  #     BPQETHER m
  #     BAYCOM_SER_FDX m
  #     BAYCOM_SER_HDX m
  #     YAM m
  #   '';
  # }];

  # boot.kernelModules = [ "ax25" "mkiss" ];

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
      ax25-tools
      ax25-apps
      libax25
      (direwolf.override {
        alsa-lib = unstable.alsa-lib;
      })

      tomb
      pinentry
      pinentry-curses
    ];

  system.stateVersion = "22.05";
  networking.firewall.allowedTCPPorts = [ 8001 ];
}
