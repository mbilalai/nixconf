# modules/darwin/packages.nix
# macOS-specific system packages
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Editors and Development
    vim
    helix
    zed-editor
    claude-code

    # Rust toolchain
    rust-analyzer
    cargo
    rustc
    rustfmt
    clippy

    # Language Servers
    nil # Nix LSP
    taplo # TOML LSP

    # Core utilities
    wget
    git

    # Browsers and Apps
    brave

    # 1Password (macOS versions)
    _1password-gui
    _1password-cli

    # Terminals
    kitty
    alacritty
    # ghostty  # Not yet available for macOS in nixpkgs-unstable, install via homebrew
    zellij

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

    # Build Tools
    pkg-config
    gcc
    cmake

    # Media tools
    ffmpeg
    imagemagick

    # Development utilities
    docker
    openssh
    syncthing

    # Python development (Astral ecosystem)
    uv      # Fast Python package installer and resolver
    ruff    # Fast Python linter and formatter
    ty      # Python type checker from Astral

    # SSL/TLS
    cacert
    openssl
  ];
}
