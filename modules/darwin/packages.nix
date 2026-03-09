{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    helix
    claude-code
    opencode

    rust-analyzer
    cargo
    rustc
    rustfmt
    clippy

    nil
    taplo

    wget
    git

    brave

    _1password-gui
    _1password-cli
    tailscale

    kitty
    alacritty
    zellij

    zoxide
    neofetch
    fish
    nushell
    yazi
    jujutsu
    atuin
    starship
    fastfetch

    pkg-config
    gcc
    cmake

    ffmpeg
    imagemagick

    docker
    openssh
    syncthing

    uv
    ruff
    ty

    cacert
    openssl
    gnupg
  ];
}
