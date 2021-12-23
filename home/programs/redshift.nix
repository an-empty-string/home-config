{ options, ... }:

{
  enable = true;
  provider = "manual";

  latitude = options.loc.lat;
  longitude = options.loc.lon;

  temperature.day = options.graphicalEnvironment.colorTemperature.day;
  temperature.night = options.graphicalEnvironment.colorTemperature.night;

  tray = true;
}
