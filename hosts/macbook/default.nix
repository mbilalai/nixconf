{ config, lib, pkgs, inputs, username, ... }:

let
  # Use actual macOS username
  actualUsername = "mbk";
in
{
  # Import darwin-specific modules
  imports = [
    ../../modules/darwin/packages.nix
    ../../modules/darwin/system.nix
  ];

  # 1. Host-specific Settings for macOS
  networking.computerName = "macbook";
  networking.hostName = "macbook";

  # 2. Nix Settings
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ actualUsername ];
    };

    # Automatic garbage collection - delete builds older than 10 days
    gc = {
      automatic = true;
      interval = { Day = 1; };
      options = "--delete-older-than 10d";
    };

    # Store optimization
    optimise.automatic = true;
  };

  # 3. System primary user (required for homebrew and system defaults)
  system.primaryUser = actualUsername;

  # 4. User configuration
  users.users.${actualUsername} = {
    name = actualUsername;
    home = "/Users/${actualUsername}";
    shell = pkgs.zsh; # Use zsh as default shell
  };

  # 5. Programs
  programs = {
    zsh.enable = true; # Enable zsh system-wide
  };

  # Enable Homebrew integration for GUI apps not in nixpkgs
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap"; # Uninstall packages not in config
      autoUpdate = true;
      upgrade = true;
    };
  };

  # 6. Services (nix-daemon is managed automatically by nix-darwin)

  # 7. Documentation
  documentation.enable = true;

  # 8. Home Manager Integration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.${actualUsername} = {
      imports = [
        inputs.self.homeModules.common
      ];

      home = {
        stateVersion = "25.05";
        # Set sessionVariables
        sessionVariables = {
          EDITOR = "hx";
          VISUAL = "hx";
        };
      };
    };
  };

  # 9. State Version
  # Use version 5 which expects modern GID 350 for nixbld group
  system.stateVersion = 5;
}
