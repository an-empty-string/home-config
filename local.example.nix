{ pkgs, ... }: 

{
  username = "tris";
  displayName = "Tris Emmy Wilson";
  emailAddress = "tris@tris.fyi";
  homeDirectory = "/home/tris";

  isNixOS = true;
  isNixOSUnstable = true;

  loc.lat = 34.7;
  loc.lon = -86.6;

  python = {
    enable = true;
    package = pkgs.python39;

    additionalPythonPackages = (p: with p; [
    ]);
  };

  productivityTools.enable = true;
  productivityTools.taskd = {
    certificate = "/home/tris/.task/keys/public.cert";
    key = "/home/tris/.task/keys/private.key";
    ca = "/home/tris/.task/keys/ca.cert";
    credentials = "trisfyi/tris/00000000-0000-0000-0000-000000000000";
  };

  developmentEnvironment.enable = true;
  graphicalEnvironment = {
    enable = true;

    i3Modifier = "Mod4";

    colorTemperature.day = 5500;
    colorTemperature.night = 3700;

    kanshiProfiles = {
      undocked = {
        outputs = [ { criteria = "eDP-1"; } ];
      };
    };
  };

  gpg = {
    sshEnable = true;
    sshKeys = [ "6AC01B8D7C9C5F6006DC3C0D551030E83ECDE32C" ];

    publicKeys = [
      { source = trust/gpg/tris.asc; trust = 5; }
    ];
  };

  ssh = {
    useControlMaster = true;
  };

  additionalConfig = {
    home.packages = [
      pkgs.musescore
    ];
  };
}
