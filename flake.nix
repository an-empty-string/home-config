{
  description = "Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
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

      dripleaf = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./sys/dripleaf/configuration.nix ];
      };

      trisfyi = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./sys/trisfyi/configuration.nix ];
      };

      hsv1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./sys/hsv1/configuration.nix ];
      };

      hsv2 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./sys/hsv2/configuration.nix ];
      };
    };

    homeConfigurations = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = {
        unstable = unstable.legacyPackages.x86_64-linux;
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
          home/productivityToolsPeriodic.nix
        ];
      };
    };
  };
}
