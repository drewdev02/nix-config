{ config, pkgs, ... }:
{
  imports = [
    ./git.nix
    ./zsh.nix
    ./packages.nix
  ];

  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
