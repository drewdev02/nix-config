{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nixpkgs-unstable }:
  let
    systemRevision = self.rev or self.dirtyRev or null;
  in
  {
    darwinConfigurations."Andrews-MacBook" = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit inputs; };
      modules = [
        (import ./system.nix)
        (import ./users.nix)
        (import ./homebrew.nix)
        (import ./home-manager.nix)
        inputs.home-manager.darwinModules.home-manager
        {
          system.configurationRevision = systemRevision;
        }
      ];
    };
  };
}
