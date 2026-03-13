{ config, pkgs, ... }: {
  # macOS system preferences

  # Keyboard settings
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
    # remapCapsLockToEscape = true;
  };

  # Trackpad settings
  # system.trackpad = {
  #   Clicking = true;
  #   TrackpadThreeFingerDrag = true;
  # };

  # Dock settings
  system.defaults.dock = {
    autohide = true;
    showhidden = true;
    orientation = "bottom";
    tilesize = 48;
  };

  # Finder settings
  system.defaults.finder = {
    AppleShowAllExtensions = true;
    FXPreferredViewStyle = "Nlsv";  # List view
  };

  # Global settings
  system.defaults.NSGlobalDomain = {
    AppleShowAllFiles = true;
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticDashSubstitutionEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
    NSAutomaticQuoteSubstitutionEnabled = false;
    NSAutomaticSpellingCorrectionEnabled = false;
  };

  # Disable startup sound
  # system.startupSound = false;

  # Default shell for new users
  # environment.defaultShell = pkgs.zsh;
}
