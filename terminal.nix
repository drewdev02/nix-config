{ config, pkgs, ... }: {
  # Terminal shell configuration
  programs.zsh.enable = true;

  # Zsh configuration
  programs.zsh.interactiveShellInit = ''
    # Custom aliases
    # alias ll="ls -la"
  '';

  # Zsh plugins (requires zplug, antigen, etc.)
  programs.zsh.plugins = [
    # Example: "zsh-users/zsh-autosuggestions"
    # Example: "zsh-users/zsh-syntax-highlighting"
  ];

  # Terminal app configuration
  # programs.kitty.enable = true;
  # programs.alacritty.enable = true;
  # programs.wezterm.enable = true;

  # Starship prompt (cross-shell prompt)
  # programs.starship.enable = true;

  # GNU tools instead of BSD defaults
  # environment.systemPackages = [ pkgs.coreutils pkgs.gnugrep pkgs.gnused ];
}
