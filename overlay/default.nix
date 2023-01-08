self: super: {
  glauth = super.callPackage ./pkgs/glauth {};

  tris-upload-utils = super.callPackage ./pkgs/tris-upload-utils {};
  tris-pomodoro = super.callPackage ./pkgs/tris-pomodoro {};
  tris-mqtt-bluetooth = super.callPackage ./pkgs/tris-mqtt-bluetooth {};
  tris-bamboo-holidays = super.callPackage ./pkgs/tris-bamboo-holidays {};

  keyd = super.keyd.overrideAttrs (old: {
    src = super.fetchFromGitHub {
      owner = "rvaiya";
      repo = "keyd";
      rev = "bcfb8bb3390cb293c0b2bc72f04fd0a339d7b1ca";
      hash = "sha256-QvQkG/g8by7eGNx9rvj1fh35DzUxmNyutqD/aG3ol94=";
    };

    postPatch = ''
      sed -i '2i DESTDIR=' Makefile

      ${old.postPatch}
    '';
  });

  python310 = super.python310.override {
    packageOverrides = (pself: psuper: {
      tris-config = psuper.buildPythonPackage {
        name = "tris-config";
        src = pkgs/tris-config;
        propagatedBuildInputs = with super.python310.pkgs; [ click redis ];
      };
    });
  };
}
