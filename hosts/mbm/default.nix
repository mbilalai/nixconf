{ config, lib, pkgs, inputs, ... }:

let
  actualUsername = "mbk";
in
{
  imports = [
    ../../modules/darwin/system.nix
  ];

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
  ];

  networking.computerName = "mbm";
  networking.hostName = "mbm";

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
