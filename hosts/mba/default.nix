{ config, lib, pkgs, inputs, username, ... }:

let
  actualUsername = "mbk";
in
{
  imports = [
    ../../modules/darwin/system.nix
  ];

  environment.systemPackages = with pkgs; [
    # Editors and Development
    vim
    helix
    claude-code
    opencode

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
    # ghostty  # Not available for aarch64-darwin, use homebrew instead
    zellij

    # Window Management
    # aerospace  # Not available for aarch64-darwin

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

  networking.computerName = "mba";
  networking.hostName = "mba";

  nix = {
    enable = false;
  };

  system.primaryUser = actualUsername;

  users.users.${actualUsername} = {
    name = actualUsername;
    home = "/Users/${actualUsername}";
    shell = pkgs.zsh;
  };

  programs = {
    zsh.enable = true;
  };

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

    taps = [
      "nikitabobko/tap"
    ];

    casks = [
      "ghostty"
      "aerospace"
    ];
  };

  documentation.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.${actualUsername} = {
      imports = [
        inputs.self.homeModules.common
      ];

      home = {
        stateVersion = "25.05";
        sessionVariables = {
          EDITOR = "hx";
          VISUAL = "hx";
        };
      };
    };
  };

  system.stateVersion = 5;
}
