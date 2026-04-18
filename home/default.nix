{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    inputs.sops-nix.homeManagerModules.sops
    ./git.nix
    ./zsh.nix
    ./packages.nix
    ./nixvim.nix
    ./secrets.nix
  ];

  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
