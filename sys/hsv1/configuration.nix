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

  services.syncthing.enable = true;

  users.users.calibre-server.uid = 8001;

  services.calibre-server = {
    enable = true;
    user = "calibre-server";
    libraries = [
      "/net/hsv1/calibre-library"
    ];
  };

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
