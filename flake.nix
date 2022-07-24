{
  description = "Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, unstable, home-manager }: {
    nixosConfigurations = {
      terracotta = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./sys/terracotta/configuration.nix ];
      };

      deepslate = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./sys/deepslate/configuration.nix ];
      };
    };

    homeConfigurations = let
      system = "x86_64-linux";
      homeDirectory = "/home/tris";
      username = "tris";
      stateVersion = "21.11";
      mkOptions = attrs: options: attrs // { inherit options; };
      subConfigs = paths: { lib, pkgs, config, ... }: lib.mkMerge (
        map (path: (
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
