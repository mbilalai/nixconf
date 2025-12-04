{ config, pkgs, ...}:

{
  services.ssh-agent.enable = true;
  services.ssh-agent.keys = [
    "~/.ssh/id_ed25519_github"
    "~/.ssh./id_ed25519_gitlab"
  ];
}
