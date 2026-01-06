{ config, lib, pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./git.nix
    ./bash.nix
    ./zsh.nix
    # Add other shared user configs here (e.g., ./nvim.nix)
  ];
}
