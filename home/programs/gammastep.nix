{ options, ... }: {
  enable = true;
  latitude = options.loc.lat;
  longitude = options.loc.lon;
  temperature = options.graphicalEnvironment.colorTemperature;
}
