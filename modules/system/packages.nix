# modules/system/packages.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ #
    # Editors and Shells
    vim
    helix
    zed-editor
    claude-code
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
    docker
    mujoco
    pkgs.nur.repos.Ev357.helium
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
