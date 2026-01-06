{ config, pkgs, inputs, ... }:

{
  # Enable COSMIC Desktop Environment (Latest Available Version)
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
  
  # Use COSMIC's native display manager instead of GDM for better integration
  services.xserver.enable = false;  # Disable X server as COSMIC is Wayland-only
  services.xserver.displayManager.gdm.enable = false;

  # 2. XDG Portal with COSMIC support
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [ 
    xdg-desktop-portal-cosmic  # COSMIC-specific portal for better integration
    xdg-desktop-portal-gtk     # Fallback for compatibility
  ];
  xdg.portal.config.cosmic.default = ["cosmic" "gtk"];


  # 4. COSMIC-specific Environment Variables
  environment.sessionVariables = {
    # Wayland optimization
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    
    # COSMIC-specific optimizations
    COSMIC_DATA_CONTROL_ENABLED = "1";      # Enable data control protocol
    COSMIC_DISABLE_DIRECT_SCANOUT = "0";    # Enable direct scanout for better performance
    
    # Better application compatibility
    QT_QPA_PLATFORM = "wayland;xcb";        # Qt applications prefer Wayland
    GDK_BACKEND = "wayland,x11";            # GTK applications prefer Wayland
    SDL_VIDEODRIVER = "wayland";            # SDL applications use Wayland
    _JAVA_AWT_WM_NONREPARENTING = "1";      # Fix Java applications
    
    # Enable hardware acceleration for WebKit
    WEBKIT_DISABLE_COMPOSITING_MODE = "0";
  };

  # Enable PolicyKit for GUI applications
  security.polkit.enable = true;

  # 5. Additional COSMIC Applications (from stable/unstable packages)
  environment.systemPackages = with pkgs; [
    # Use unstable packages for latest COSMIC apps when available
    (inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.cosmic-files or cosmic-files)
    (inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.cosmic-edit or cosmic-edit)
    (inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.cosmic-term or cosmic-term)
    (inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.cosmic-settings or cosmic-settings)
    (inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.cosmic-applibrary or cosmic-applibrary)
    cosmic-wallpapers   # COSMIC wallpapers
    cosmic-icons        # COSMIC icon theme
  ];

  # 6. Hardware acceleration for better graphics performance
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
}
