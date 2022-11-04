{ pkgs, ... }:

{
  imports = [
    ./generated.nix
    ../modules/common.nix
  ];

  networking.hostName = "hsv1";
  time.timeZone = "Etc/UTC";

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/vda";
  };

  networking.interfaces.enp1s0.useDHCP = true;
  boot.kernel.sysctl."net.ipv4.ip_forward" = "1";

  # Redis (Tailscale only)
  services.redis.servers.trisfyi = {
    enable = true;

    bind = null;
    port = 6379;

    settings = {
      "protected-mode" = "no";
    };
  };

  system.stateVersion = "22.05";
}
