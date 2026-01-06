{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "mbilalai";
    userEmail = "mbilalai@protonmail.ch";
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "helix";
    };
  };
}
