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
      core.editor = "helix";
    };
  };
}
