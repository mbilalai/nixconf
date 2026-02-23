{ config, lib, pkgs, inputs, ... }:

let
  actualUsername = "mbk";
in
{
  imports = [
    ../../modules/darwin/packages.nix
    ../../modules/darwin/system.nix
  ];

  networking.computerName = "mbp";
  networking.hostName = "mbp";

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
