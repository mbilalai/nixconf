{ config, lib, pkgs, ... }:

{
  programs.bash = {
    enable = true;

    initExtra = ''
      # Initialize zoxide
      eval "$(zoxide init bash)"

      # Initialize starship prompt
      eval "$(starship init bash)"

      # Initialize atuin
      eval "$(atuin init bash)"

      # Nix rebuild functions
      ndr() {
        local host="$1"
        if [ -z "$host" ]; then host="mba"; fi
        sudo ~/.nix-profile/bin/darwin-rebuild switch --flake "/Users/mbk/nixconf#$host"
      }

      nrs() {
        local host="$1"
        if [ -z "$host" ]; then host="alpha"; fi
        sudo nixos-rebuild switch --flake "/Users/mbk/nixconf#$host"
      }
    '';

    shellAliases = {
      ndr = "ndr mba";
      nrs = "nrs alpha";
      nfu = "nix flake update";
      nfc = "nix flake check";

      ll = "ls -lah";
      la = "ls -A";

      g = "git";
      gs = "git status";
      gd = "git diff";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
    };

    historySize = 10000;
  };
}
