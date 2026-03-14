{ inputs, pkgs-unstable, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Pass additional arguments to home-manager modules
  home-manager.extraSpecialArgs = { inherit inputs pkgs-unstable; };

  # Import user configuration
  home-manager.users.Andrew = import ./home;
}
