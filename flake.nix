{
  description = "Modular, Reproducible, and Cross-Platform Nix Configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-darwin = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, home-manager-darwin, darwin, nur, ... } @ inputs:
  let
    x86_64-linux = "x86_64-linux";
    aarch64-darwin = "aarch64-darwin";

    username = "alpha";

    darwinHosts = [ "mba" "mbp" "mm" "ms" ];
    nixosHosts = [ "alpha" "lap" "tb" "box" ];

    mkPkgs = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;

        overlays = [
          (final: prev: {
            unstable = import inputs.nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          })
        ]  ++ [ nur.overlays.default ];
      };

    mkPkgsDarwin = system:
      import inputs.nixpkgs-darwin {
        inherit system;
        config.allowUnfree = true;

        overlays = [
          nur.overlays.default
        ];
      };

    specialArgs = {
      inherit inputs username;
      pkgs-stable = mkPkgs x86_64-linux;
      pkgs-darwin = mkPkgs aarch64-darwin;
    };

    mkDarwinSystem = hostName:
      darwin.lib.darwinSystem {
        system = aarch64-darwin;
        inherit specialArgs;

        modules = [
          ({ ... }: {
            nixpkgs.pkgs = mkPkgsDarwin aarch64-darwin;
          })
          ./hosts/${hostName}/default.nix
          home-manager-darwin.darwinModules.home-manager
        ];
      };

    mkNixosSystem = hostName:
      nixpkgs.lib.nixosSystem {
        system = x86_64-linux;
        inherit specialArgs;

        modules = [
          ({ ... }: {
            nixpkgs.pkgs = mkPkgs x86_64-linux;
          })
          ./hosts/${hostName}/configuration.nix
          ./modules/system/default.nix
          ./modules/desktop/gdm-cosmic.nix
          ./modules/nixos/packages.nix
          ./modules/system/lid-display-switch.nix
          home-manager.nixosModules.home-manager
        ];
      };

  in {
    nixosConfigurations = builtins.listToAttrs (
      map (hostName: {
        name = hostName;
        value = mkNixosSystem hostName;
      }) nixosHosts
    );

    darwinConfigurations = builtins.listToAttrs (
      map (hostName: {
        name = hostName;
        value = mkDarwinSystem hostName;
      }) darwinHosts
    );

    homeModules = {
      common = { config, lib, pkgs, ... }:
        import ./home/common/default.nix {
          inherit config lib pkgs inputs;
        };
    };

    formatter = {
      ${x86_64-linux} = (mkPkgs x86_64-linux).nixfmt-classic;
      ${aarch64-darwin} = (mkPkgs aarch64-darwin).nixfmt-classic;
    };
  };
}
