{ pkgs, ... }: 

{
  username = "tris";
  displayName = "Tris Emmy Wilson";
  emailAddress = "tris@tris.fyi";
  homeDirectory = "/home/tris";

  loc.lat = 34.7;
  loc.lon = -86.6;

  python = {
    enable = true;
    package = pkgs.python39;

    additionalPythonPackages = (p: with p; [
    ]);
  };

  graphicalEnvironment = {
    enable = true;

    i3Modifier = "Mod4";

    colorTemperature.day = 5500;
    colorTemperature.night = 3700;
  };

  additionalConfig = {
  };
}
