{
  description = "Modular, Reproducible, and Cross-Platform Nix Configs";

  inputs = {
    # 1. Core Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # 2. Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 3. nix-darwin
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 4. NUR (Nix User Repository)
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, darwin, nur, ... } @ inputs:
  let
    # Define systems
    x86_64-linux = "x86_64-linux";
    aarch64-darwin = "aarch64-darwin";

    # User / host constants
    username = "alpha";
    hostname_alpha = "alpha";
    hostname_macbook = "macbook";

    # Helper function to import pkgs with overlays
    mkPkgs = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;

        overlays = [
          # Unstable packages under pkgs.unstable
          (final: prev: {
            unstable = import inputs.nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          })

          # NUR overlay
          nur.overlay
        ];
      };

    # Arguments passed to all modules
    specialArgs = {
      inherit inputs username;
      pkgs-stable = mkPkgs x86_64-linux;
      pkgs-darwin = mkPkgs aarch64-darwin;
    };

  in {
    # 1. NixOS Configurations
    nixosConfigurations = {
      ${hostname_alpha} = nixpkgs.lib.nixosSystem {
        system = x86_64-linux;
        inherit specialArgs;

        modules = [
          ./hosts/${hostname_alpha}/configuration.nix

          ./modules/system/default.nix
          ./modules/desktop/gdm-cosmic.nix
          ./modules/system/packages.nix

          home-manager.nixosModules.home-manager
        ];
      };
    };

    # 2. nix-darwin Configurations
    darwinConfigurations = {
      ${hostname_macbook} = darwin.lib.darwinSystem {
        system = aarch64-darwin;
        inherit specialArgs;

        modules = [
          ./hosts/${hostname_macbook}/default.nix
          home-manager.darwinModules.home-manager
        ];
      };
    };

    # 3. Home Manager modules
    homeModules = {
      common = { config, lib, pkgs, ... }:
        import ./home/common/default.nix {
          inherit config lib pkgs inputs;
        };
    };

    # Formatter
    formatter = nixpkgs.lib.defaultFormatter;
  };
}

