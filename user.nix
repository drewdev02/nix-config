{ config, pkgs, ... }: {
  # User configuration
  users.users.andrew = {
    home = "/Users/andrew";
    shell = pkgs.zsh;
  };

  # Home Manager integration (optional)
  # home-manager.users.andrew = { ... };

  # User-specific packages
  # home.packages = [ pkgs.git ];

  # User-specific settings
  # programs.git.enable = true;
}
