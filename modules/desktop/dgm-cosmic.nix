{ config, pkgs, ... }:

{
  # 1. X Server and Display
  services.xserver.enable = true; #
  services.xserver.displayManager.gdm.enable = true; #
  services.desktopManager.cosmic.enable = true; #

  # 2. XDG Portal
  xdg.portal.enable = true; #
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; #

  # 3. Fingerprint Settings
  services.fprintd.enable = true; #
  services.fprintd.tod.enable = true; #
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix; #
  security.pam.services.gdm.fprintAuth = true; #
  security.pam.services.gdm-password.fprintAuth = true; #

  # 4. Session Environment Variables
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1"; #
    NIXOS_OZONE_WL = "1"; #
  };
}
