{
  description = "Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, unstable, home-manager }: {
    homeConfigurations = let
      system = "x86_64-linux";
      homeDirectory = "/home/tris";
      username = "tris";
      stateVersion = "21.11";
      mkOptions = attrs: options: attrs // { inherit options; };
      subConfigs = paths: { lib, pkgs, config, ... }: lib.mkMerge (
        map (path: builtins.trace path (
          (import path) ({
            inherit lib pkgs config;
            localCallPackage = p: ((import p) {
              inherit lib pkgs config nixpkgs unstable;
            });
          })
        )) paths);
    in {
      base = home-manager.lib.homeManagerConfiguration {
        inherit system homeDirectory username stateVersion;

        configuration = subConfigs [ home/base.nix ];
      };

      laptop = home-manager.lib.homeManagerConfiguration {
        inherit system homeDirectory username stateVersion;

        configuration = subConfigs [
          home/base.nix
          home/laptop.nix
          home/package-sets/productivityTools.nix
        ];
      };
    };
  };
}
