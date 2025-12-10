{
  description = "Modular, Reproducible, and Cross-Platform Nix Configs";

  inputs = {
    # 1. Core Nixpkgs
    # Using stable for OS components
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # Use an unstable version for up-to-date applications and packages
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # 2. Home Manager (for user-level config)
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 3. nix-darwin (for macOS system configuration)
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... } @ inputs:
  let
    # Define systems for reuse
    x86_64-linux = "x86_64-linux";
    aarch64-darwin = "aarch64-darwin";

    # Define the primary user and hostname constants
    username = "alpha";
    hostname_alpha = "alpha";
    hostname_macbook = "macbook";

    # Helper function to import a pkgs set with unstable overlay and unfree packages enabled
    mkPkgs = system:
      import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          # Overlay to access unstable packages via 'pkgs.unstable'
          overlays = [
            (final: prev: {
              unstable = import inputs.nixpkgs-unstable {
                inherit system;
                config.allowUnfree = true;
              };
            })
          ];
        };
      };

    # Arguments passed to all modules (e.g., username, inputs)
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
          # Import the Host-Specific configuration (including hardware-configuration.nix)
          ./hosts/${hostname_alpha}/configuration.nix

          # Import all reusable NixOS modules
          ./modules/system/default.nix
          ./modules/desktop/gdm-cosmic.nix
          ./modules/system/packages.nix

          # Enable Home Manager as a NixOS module
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
          # Import the Host-Specific configuration for the Mac
          ./hosts/${hostname_macbook}/default.nix

          # Enable Home Manager as a nix-darwin module
          home-manager.darwinModules.home-manager
        ];
      };
    };
    
   homeModules = {
     common = { config, lib, pkgs, ...}:
       import ./home/common/default.nix {
         inherit config lib pkgs;
         inherit inputs;
       };
    };
    
    homeModules = {
     common = import ./home/common/default.nix { inherit inputs; };

   homeModules = {
     common = { config, lib, pkgs, ...}:
       import ./home/common/default.nix {
         inherit config lib pkgs;
         inherit inputs;
       };
    };
# >>>>>>> c01a5f1 (expose homemodules in flake outputs)

    # Optional: Set a default formatter for all Nix files
    formatter = nixpkgs.lib.defaultFormatter;
  };
}
