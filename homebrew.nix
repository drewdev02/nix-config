{ config, pkgs, ... }: {
  # Homebrew integration
  homebrew.enable = true;

  # CLI tools installed via Homebrew
  homebrew.brews = [
    # Example: "git"
    # Example: "wget"
  ];

  # GUI applications installed via Homebrew
  homebrew.casks = [
    # Example: "firefox"
    # Example: "visual-studio-code"
  ];

  # Homebrew configuration
  homebrew.onActivation = {
    autoUpdate = true;
    upgrade = true;
    cleanup = "zap";
  };
}
