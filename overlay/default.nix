self: super: {
  tris-upload-utils = super.callPackage ./pkgs/tris-upload-utils {};
  tris-pomodoro = super.callPackage ./pkgs/tris-pomodoro {};
  tris-bamboo-holidays = super.callPackage ./pkgs/tris-bamboo-holidays {};

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
