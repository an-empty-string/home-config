{ ... }: {
  services.gammastep = {
    enable = true;
    latitude = 34.7;
    longitude = -86.6;
    temperature.day = 5500;
    temperature.night = 3700;
  };
}
