{ config, lib, pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./git.nix
    ./bash.nix
    # Add other shared user configs here (e.g., ./zsh.nix, ./nvim.nix)
  ];
}
