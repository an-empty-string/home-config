{
  description = "Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, unstable, home-manager }: let
    x64Home = (modules: home-manager.lib.homeManagerConfiguration {
      inherit modules;
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = { inherit unstable; };
    });
  in {
    homeConfigurations = {
      trisfyi = x64Home [ home/base.nix ];
      terracotta = x64Home [
        home/base.nix
        home/laptop.nix
        home/package-sets/productivityTools.nix
      ];
    };
  };
}
