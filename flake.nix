{
  description = "Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    sway-tris = {
      url = "github:an-empty-string/sway-hacks/tris-patches";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    amethyst = {
      url = "github:an-empty-string/amethyst";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, unstable, sway-tris, home-manager, amethyst }: let
    mkSystem = mainMod: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        mainMod
        amethyst.nixosModules.default
      ];
      specialArgs = {
        unstable = unstable.legacyPackages.x86_64-linux;
      };
    }; in {
    nixosConfigurations = {
      shulkerbox = mkSystem ./sys/shulkerbox/configuration.nix;
      terracotta = mkSystem ./sys/terracotta/configuration.nix;
      deepslate = mkSystem ./sys/deepslate/configuration.nix;
      dripleaf = mkSystem ./sys/dripleaf/configuration.nix;
      trisfyi = mkSystem ./sys/trisfyi/configuration.nix;
      beacon = mkSystem ./sys/beacon/configuration.nix;
      hsv1 = mkSystem ./sys/hsv1/configuration.nix;
      hsv2 = mkSystem ./sys/hsv2/configuration.nix;
    };

    homeConfigurations = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = {
        unstable = unstable.legacyPackages.x86_64-linux;
        sway-tris = sway-tris.packages.x86_64-linux.default;
      };
    in {
      base = home-manager.lib.homeManagerConfiguration {
        inherit pkgs extraSpecialArgs;
        modules = [ home/base.nix ];
      };

      laptop = home-manager.lib.homeManagerConfiguration {
        inherit pkgs extraSpecialArgs;
        modules = [
          home/base.nix
          home/laptop.nix
          home/productivityTools.nix
        ];
      };

      trisfyi = home-manager.lib.homeManagerConfiguration {
        inherit pkgs extraSpecialArgs;
        modules = [
          home/base.nix
          home/productivityTools.nix
        ];
      };
    };
  };
}
