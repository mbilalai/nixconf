{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "mbilalai";
    userEmail = "mbilalai@protonmail.ch";
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "vim";
      core.sshCommand = "ssh -o AddKeysToAgent=yes";
    };

    lfs.enable = true;

    difftastic.enable = true;

    ignores = [
      ".DS_Store"
      "*.swp"
      "*~"
      ".env"
      ".env.local"
    ];

    signing = {
      signByDefault = true;
      key = "mbilalai@protonmail.ch";
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        host = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
      "gitlab.com" = {
        host = "gitlab.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}
