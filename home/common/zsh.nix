{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    loginExtra = ''
      # Source .zshrc for login shells
      if [ -f "$HOME/.zshrc" ]; then
        source "$HOME/.zshrc"
      fi
    '';

    initContent = ''
      eval "$(zoxide init zsh)"
      eval "$(starship init zsh)"
      eval "$(atuin init zsh)"

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
      ndrs = "nrs alpha";
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

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };
}
