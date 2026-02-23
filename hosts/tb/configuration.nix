{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "tb";
  time.timeZone = "Australia/Sydney";
  system.stateVersion = "25.05";

  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  services.tailscale.enable = true;

  virtualisation.docker.enable = true;

  users.users.alpha = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.bash;
  };

  home-manager.users.alpha = {
    imports = [
      inputs.self.homeModules.common
    ];
    home.stateVersion = "25.05";
  };
}
