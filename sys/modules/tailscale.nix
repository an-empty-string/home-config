{ lib, pkgs, config, ... }: with lib; let
  cfg = config.services.instanced-tailscale;
  pkg = pkgs.tailscale;
in {
  options.services.instanced-tailscale = mkOption {
    type = types.attrsOf (types.submodule {
      options = {
        port = mkOption { type = types.port; };
        interfaceName = mkOption { type = types.str; };
      };
    });
  };

  config = {
    environment.systemPackages = [ pkg ];

    systemd.packages = attrsets.mapAttrsToList (name: value:
      (pkgs.runCommand "instanced-tailscale-${name}" {} ''
        mkdir -p $out/lib/systemd/system
        sed -e '/^ExecStart=/d' ${pkg}/lib/systemd/system/tailscaled.service > $out/lib/systemd/system/tailscaled@${name}.service
      '')
    ) cfg;

    systemd.services = mkMerge (attrsets.mapAttrsToList (name: value: {
      "tailscaled@${name}" = {
        wantedBy = [ "multi-user.target" ];
        path = [
        ];

        serviceConfig.ExecStart = "${pkg}/bin/tailscaled --port ${toString value.port} --tun ${escapeShellArg value.interfaceName} --socket=/run/tailscale/${name}.sock --statedir=/var/lib/tailscale/${name} --state=/var/lib/tailscale/${name}/state";
        stopIfChanged = false;
      };
    }) cfg);

    networking.dhcpcd.denyInterfaces = (attrsets.mapAttrsToList (name: value: value.interfaceName));
  };
}
