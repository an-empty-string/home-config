{ config, lib, pkgs, ... }: lib.mkMerge [
  {
    environment.systemPackages = [ pkgs.nfs-utils ];
    services.nfs.server.enable = true;
    services.rpcbind.enable = true;
  }

  (let expose = (host: path: (lib.mkMerge [
    (lib.mkIf (config.networking.hostName != host) {
      systemd.mounts = [{
        type = "nfs";
        mountConfig.Options = "noatime";
        what = "${host}:${path}";
        where = "/net/${host}${path}";
      }];

      systemd.automounts = [{
        wantedBy = [ "multi-user.target"];
        automountConfig.TimeoutIdleSec = "600";
        where = "/net/${host}${path}";
      }];
    })

    (lib.mkIf (config.networking.hostName == host) {
      services.nfs.server.exports = ''
        ${path} 100.64.0.0/10(rw,fsid=0,no_subtree_check)
      '';
    })
  ])); in lib.mkMerge [
    (expose "beacon" "/data/pictures")
  ])
]
