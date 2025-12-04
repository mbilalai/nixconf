{ config, lib, pkgs, inputs, username, ... }:

{
  # 1. Host-specific Settings for macOS
  networking.computerName = "macbook";
  networking.hostName = "macbook";
  # Set the macOS user account
  users.users.${username}.name = username;
  users.users.${username}.home = "/Users/${username}";

  # 2. Darwin Settings (Mac equivalent of NixOS services)
  # Enable the Nix Darwin manual
  documentation.enable = true;

  # Enable Homebrew integration (optional)
  programs.homebrew.enable = true;

  # Set the default shell to Fish (must be installed via Home Manager or system)
  programs.fish.enable = true;
  # This makes the fish shell the default login shell.
  users.users.${username}.shell = pkgs.fish;

  # 3. Home Manager Integration (Points to same user-level configuration)
  home-manager.users.${username} = {
    imports = [
      inputs.self.homeModules.common # Imports packages, git config, etc.
      # Add macOS-specific home-manager files here if needed
      # e.g., for setting up applications like alacritty and kitty on macOS
    ];

    home.stateVersion = "25.05"; # Should match the home-manager input
  };

  # 4. State Version
  # You must start with a state version, then never change it.
  system.stateVersion = 4;
}
