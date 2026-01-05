# modules/system/packages.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ #
    # Editors and Shells
    vim
    helix
    zed-editor
    claude-code
    # Development Tools
    rust-analyzer
    cargo
    rustc
    rustfmt
    clippy
    # Language Servers and Tools
    nil # Nix LSP
    taplo # TOML LSP
    # Browsers and Utils
    wget
    git
    brave
    _1password-gui
    # Authentication and Security
    gnome-keyring
    libsecret
    # SSL/TLS Support
    cacert
    openssl
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
    # Package Managers and Build Tools
    pkg-config
    gcc
    cmake
    # Media and Graphics
    ffmpeg
    imagemagick
  ];
}
