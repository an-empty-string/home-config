self: super: {
  comic-mono-font = super.callPackage ./pkgs/comic-mono-font {};
  tris-upload-utils = super.callPackage ./pkgs/tris-upload-utils {};
  tris-pomodoro = super.callPackage ./pkgs/tris-pomodoro {};
}
