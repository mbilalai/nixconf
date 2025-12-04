# hosts/alpha/configuration.nix
{ config, lib, pkgs, inputs, username, ... }:

{
  # 1. Host-specific Imports (Hardware)
  imports = [
    ./hardware-configuration.nix
  ];

  # 2. Host-specific Settings
  networking.hostName = "alpha"; #
  time.timeZone = "Australia/Sydney"; #
  system.stateVersion = "25.05"; #

  # 3. Mullvad VPN (This service should be enabled per-host)
  services.mullvad-vpn.enable = true; #
  services.mullvad-vpn.package = pkgs.mullvad-vpn; #

  # 4. Tailscale (This service should be enabled per-host)
  services.tailscale.enable = true; #

  # 5. VirtualBox (Host-specific)
  virtualisation.virtualbox.host.enable = true; #
  users.extraGroups.vboxusers.members = [ username ]; # Users with access to VirtualBox

  # 6. User Definition (System-level)
  # Defines the user account on the NixOS system.
  users.users.${username} = {
    isNormalUser = true; #
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.fish; # Use fish as the default shell (it's in your packages list)
  };

  # 7. Home Manager Integration (Points to user-level configuration)
  home-manager.users.${username} = {
    imports = [
      inputs.self.homeModules.common # Import all shared user settings
    ];
    # Home Manager needs its own state version
    home.stateVersion = "23.11"; # Should match the home-manager input
  };
}
