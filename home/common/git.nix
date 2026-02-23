{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "mbilalai";
        email = "mbilalai@protonmail.ch";
      };
      init.defaultBranch = "main";
      core.editor = "vim";
      core.sshCommand = "ssh -o AddKeysToAgent=yes";
    };

    lfs.enable = true;

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

  programs.difftastic = {
    enable = true;
    git.enable = true;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
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
