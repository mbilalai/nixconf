# modules/system/default.nix
{ config, lib, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" "pipe-operators" ]; #
#  nixpkgs.config.allowUnfree = true; # Removed: now handled by mkPkgs in flake.nix

  # Automatic garbage collection - delete builds older than 10 days
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 10d";
  };

  boot.loader.systemd-boot.enable = true; #
  boot.loader.efi.canTouchEfiVariables = true; #

  networking.networkmanager.enable = true; #

  security.rtkit.enable = true; #
  services.pipewire = { #
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;
  };

  fonts.packages = with pkgs; [ #
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];

  hardware.bluetooth.enable = true; #
  
  # Enable gnome-keyring for authentication support (needed for Zed sign-in)
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  
  # Enable dbus for applications
  services.dbus.enable = true;
}
