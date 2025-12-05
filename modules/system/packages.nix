# modules/system/packages.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ #
    # Editors and Shells
    vim
    helix
    zed-editor
    # Browsers and Utils
    wget
    git
    brave
    _1password-gui
    # Terminals
    kitty
    alacritty
    ghostty
    zellij
    # Desktop Tools
    arandr
    xorg.xrandr
    pwvucontrol
    qbittorrent
    syncthing
    openssh
    discord
    # Shell Utilities
    zoxide
    neofetch
    fish
    nushell
    yazi
    jujutsu
    atuin
    starship
    fastfetch
    rustup
  ];
}
