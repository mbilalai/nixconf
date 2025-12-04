{ config, pkgs, ... }:

{
  # User-specific packages
  home.packages = with pkgs; [
    tree # Moved from users.users.alpha.packages
  ];
}
