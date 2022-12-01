{ pkgs, ... }: {
  services.postgresql = {
    enable = true;
    ensureUsers = [{
      name = "tris";
      ensurePermissions = {
        "DATABASE tris" = "ALL PRIVILEGES";
      };
    }];
    ensureDatabases = [ "tris" ];
    extraPlugins = [
      pkgs.postgresql13Packages.postgis
    ];
  };
}
