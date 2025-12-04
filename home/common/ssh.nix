{ config, pkgs, ...}:

{
  services.ssh-agent = true;
  services.ssh-agent.keys = [
    "~/.ssh/id_ed25519_github"
    "~/.ssh./id_ed25519_gitlab"
  ];
}
