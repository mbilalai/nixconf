{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initExtra = ''
      # Initialize zoxide
      eval "$(zoxide init zsh)"

      # Initialize starship prompt
      eval "$(starship init zsh)"

      # Initialize atuin
      eval "$(atuin init zsh)"
    '';

    shellAliases = {
      # Nix aliases
      nr = "darwin-rebuild switch --flake ~/.config/nixconf#macbook";
      nrs = "darwin-rebuild switch --flake ~/.config/nixconf#macbook";
      nfu = "nix flake update";
      nfc = "nix flake check";

      # Common aliases
      ll = "ls -lah";
      la = "ls -A";

      # Git shortcuts
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
