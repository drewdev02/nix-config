{ pkgs, pkgs-unstable, ... }:
let
  ollama = pkgs-unstable.ollama;
in
{
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Set primary user
  system.primaryUser = "Andrew";

  # Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # Dock configuration
  system.defaults.dock.autohide = false;

  # Nixpkgs configuration
  nixpkgs.config = {
    allowUnfree = true;
  };

  # System packages (stable from 25.05, ollama from unstable)
  environment.systemPackages = [
    pkgs.git
    pkgs.nix-du
    pkgs.tmux
    pkgs.tree
    pkgs.curl
    ollama
  ];

  # Ollama service - runs locally hosted LLMs
  # Using launchd user agent since services.ollama is not available in nix-darwin
  launchd.user.agents.ollama = {
   # serviceConfig = {
    #  Label = "org.nixos.ollama";
     # ProgramArguments = [
      #  "${ollama}/bin/ollama"
       # "serve"
     # ];
     # KeepAlive = true;
      #RunAtLoad = true;
     # EnvironmentVariables = {
      #  OLLAMA_HOST = "127.0.0.1:11434";
      #};
      #StandardOutPath = "/tmp/ollama.log";
      #StandardErrorPath = "/tmp/ollama.error.log";
    #};
  };

  # Enable zsh at system level
  programs.zsh.enable = true;

  # Used for backwards compatibility
  system.stateVersion = 6;

  # The platform the configuration will be used on
  nixpkgs.hostPlatform = "aarch64-darwin";
}
