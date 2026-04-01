{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./git.nix
    ./zsh.nix
    ./packages.nix
    ./nixvim.nix
  ];

  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
