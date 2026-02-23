{ config, lib, pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./git.nix
    ./bash.nix
    ./zsh.nix
    ./aerospace.nix
  ];
}
