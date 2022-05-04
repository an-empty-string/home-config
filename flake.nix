{
  description = "Home Manager configurations";

  inputs = {
    nixpkgs.url = "flake:nixpkgs";
    homeManager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, homeManager }: {
    homeConfigurations = {
      main = homeManager.lib.homeManagerConfiguration {
        configuration = (import ./home.nix);

        system = "x86_64-linux";
        homeDirectory = "/home/tris";
        username = "tris";
        stateVersion = "21.05";
      }
    };
  };
}
