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

  virtualisation.docker.enable = true;

  networking.wireguard.interfaces.wg0 = {
    ips = [
      "fdd2:972a:b48c::1/64"
      "100.127.255.1/24"
    ];

    peers = [
      {
        publicKey = "EPtzMkbJF6vGOgQdZUv4sIk7yNp6PRUzdyl+2zoOY2s=";
        allowedIPs = [
          "fdd2:972a:b48c::2/128"
          "100.127.255.2/32"
        ];
      }
    ];

    listenPort = 51821;
    privateKeyFile = "/etc/wireguard/wg0.key";
    generatePrivateKeyFile = true;
  };

  system.stateVersion = "22.05";
}
