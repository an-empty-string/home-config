{ pkgs, ... }:

{

  enable = true;
  package = pkgs.callPackage ({ lib
      , rustPlatform
      , fetchFromGitHub
      , pkg-config
      , makeWrapper
      , dbus
      , libpulseaudio
      , notmuch
      , openssl
      , ethtool
      , lm_sensors
      , iw
      , iproute2
    }:

    rustPlatform.buildRustPackage rec {
      pname = "i3status-rust";
      version = "0.21.6";

      src = fetchFromGitHub {
        owner = "an-empty-string";
        repo = pname;
        rev = "892407067aec2757a75cc5a52adad80069859889";
        sha256 = "sha256-Yy1f7EhsDLrtzw9k84mbX0uW0mgwCqFmslcWjdrqcoQ=";
      };

      cargoSha256 = "sha256-k+YK5cX6e58lDZ7/dMUxE3GT9X/d/l38VteTq5fLAUI=";

      nativeBuildInputs = [ pkg-config makeWrapper ];

      buildInputs = [ dbus libpulseaudio notmuch openssl lm_sensors ];

      buildFeatures = [];
      prePatch = ''
        substituteInPlace src/util.rs \
          --replace "/usr/share/i3status-rust" "$out/share"
      '';

      postInstall = ''
        mkdir -p $out/share
        cp -R examples files/* $out/share
      '';

      postFixup = ''
        wrapProgram $out/bin/i3status-rs --prefix PATH : ${lib.makeBinPath [ iproute2 ethtool iw ]}
      '';

      # Currently no tests are implemented, so we avoid building the package twice
      doCheck = false;

      meta = with lib; {
        description = "Very resource-friendly and feature-rich replacement for i3status";
        homepage = "https://github.com/greshake/i3status-rust";
        license = licenses.gpl3Only;
        maintainers = with maintainers; [ backuitist globin ma27 ];
        platforms = platforms.linux;
      };
    }) {};

  bars.default = {
    blocks = [
      {
        block = "custom";
        persistent = true;
        command = "mosquitto_sub -t pomodoro/statusline";
        click = [
          { button = "left"; cmd = "mosquitto_pub -t pomodoro/command -m trigger"; }
          { button = "right"; cmd = "mosquitto_pub -t pomodoro/command -m reset"; }
        ];
      }
      { block = "battery"; format = "{percentage} {time}"; device = "BAT0"; }
      { block = "time"; format = "%Y-%m-%d %H:%M"; }
    ];

    theme = "native";
    icons = "awesome5";
  };
}
