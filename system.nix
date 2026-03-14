{ pkgs, ... }: {
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Set primary user
  system.primaryUser = "Andrew";

  # Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # Dock configuration
  system.defaults.dock.autohide = false;

  # System packages
  environment.systemPackages = with pkgs; [
    git
    nix-du
    tmux
    tree
    curl
  ];

  # Used for backwards compatibility
  system.stateVersion = 6;

  # The platform the configuration will be used on
  nixpkgs.hostPlatform = "aarch64-darwin";
}
