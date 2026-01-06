{ config, lib, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      # Custom bash configuration
      export EDITOR="hx"
      
      # Aliases
      alias ll='ls -la'
      alias la='ls -A'
      alias l='ls -CF'
      alias grep='grep --color=auto'
      alias fgrep='fgrep --color=auto'
      alias egrep='egrep --color=auto'
      
      # History settings
      export HISTCONTROL=ignoreboth
      export HISTSIZE=1000
      export HISTFILESIZE=2000
    '';
    
    # Set bash as the default shell for Home Manager
    shellAliases = {
      # Git aliases
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline";
      
      # System aliases
      rebuild-nixos = "sudo nixos-rebuild switch --flake .#alpha";
      rebuild-darwin = "darwin-rebuild switch --flake .#macbook";
      update-flake = "nix flake update";
      check-flake = "nix flake check";
    };
  };
}