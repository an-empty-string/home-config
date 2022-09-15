{ pkgs, ... }:

{
  imports = [
    ./generated.nix
    ../modules/common.nix
  ];

  networking.hostName = "hsv2";
  time.timeZone = "Etc/UTC";

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  networking.interfaces.enp2s0.useDHCP = true;
  boot.kernel.sysctl."net.ipv4.ip_forward" = "1";

  system.stateVersion = "22.05";
}
