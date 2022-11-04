{ config, lib, pkgs, ... }: lib.mkMerge [
  {
    environment.systemPackages = [ pkgs.nfs-utils ];
    services.rpcbind.enable = true;
  }

  (lib.mkIf (config.networking.hostName != "hsv1") {
    systemd.mounts = [{
      type = "nfs";
      mountConfig.Options = "noatime";
      what = "hsv1:/net/hsv1";
      where = "/net/hsv1";
    }];

    systemd.automounts = [{
      wantedBy = [ "multi-user.target"];
      automountConfig.TimeoutIdleSec = "600";
      where = "/net/hsv1";
    }];
  })
]
