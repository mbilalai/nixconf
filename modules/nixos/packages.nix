{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    vim
    helix
    zed-editor
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

    gnome-keyring
    libsecret
    cacert
    openssl

    kitty
    alacritty
    ghostty
    zellij

    arandr
    xorg.xrandr
    pwvucontrol
    qbittorrent
    syncthing
    openssh
    discord
    docker
    mujoco
    spotify

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
    steam

    uv
    ruff
    ty
  ];
}
