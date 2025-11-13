{
  description = "NixOS config flake with host + desktop selection";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";

    # Helper function to build a host with a desktop module
    mkHost = host: desktop:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; froot = ./.; };
        modules = [
          ./hosts/${host}/configuration.nix
          ./desktop/${desktop}.nix
          inputs.home-manager.nixosModules.default
        ];
      };
  in {
    # Unfortunately, you have to list all the possible host + desktop combos here :C
    nixosConfigurations = {
      juliette-plasma = mkHost "juliette" "plasma";
      juliette-hyprland = mkHost "juliette" "hyprland";
    };
  };
}
