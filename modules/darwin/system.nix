# modules/darwin/system.nix
# macOS system settings and preferences
{ config, lib, pkgs, ... }:

{
  # System-wide settings
  system = {
    defaults = {
      # Dock settings
      dock = {
        autohide = true;
        orientation = "bottom";
        show-recents = false;
        tilesize = 48;
      };

      # Finder settings
      finder = {
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        QuitMenuItem = true;
        _FXShowPosixPathInTitle = true;
      };

      # Global macOS settings
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark"; # Dark mode
        AppleShowAllExtensions = true;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };

      # Trackpad settings
      trackpad = {
        Clicking = true; # Tap to click
        TrackpadRightClick = true;
      };

      # Screensaver
      screensaver.askForPasswordDelay = 10;
    };

    # Keyboard settings
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true; # Caps Lock → Control
    };
  };

  # Security settings
  security.pam.services.sudo_local.touchIdAuth = true; # Touch ID for sudo
}
