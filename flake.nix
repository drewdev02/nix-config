{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
          pkgs.vim
          pkgs.git
          pkgs.nix-du
        ];

      # Homebrew integration
      homebrew.enable = true;
      homebrew.taps = [
        "sdkman/tap"
      ];
      homebrew.brews = [
          "fnm"
          "uv"
          "mas"
          "sdkman/tap/sdkman-cli"
          "qwen-code"
      ];
      homebrew.casks = [
        "zed"
        "claude-code"
      ];
      homebrew.masApps = {
        "Bitwarden" = 1352778147;
      };
      homebrew.onActivation = {
        cleanup = "none";
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Set primary user for Homebrew and other user-specific options
      system.primaryUser = "Andrew";

      # Dock configuration
      system.defaults.dock.autohide = false;

      # Define user for Home Manager
      users.users.Andrew = {
        home = "/Users/Andrew";
      };

      # Home Manager - user configuration
      home-manager.users.Andrew = { pkgs, ... }: {
        home.stateVersion = "25.05";
        home.packages = [
          # Add user-specific packages here
        ];

        # Git configuration
        programs.git = {
          enable = true;
          userName = "Andrey Rodriguez";
          userEmail = "andrey.rgz.2016@gmail.com";

          extraConfig = {
            core = {
              autocrlf = "input";
              excludesfile = "/Users/Andrew/.gitignore_global";
              filemode = true;
              ignorecase = true;
              precomposeunicode = true;
            };
            http.sslverify = false;
            gpg = {
              format = "openpgp";
              program = "gpg";
            };
            commit = {
              gpgsign = false;
              template = "/Users/Andrew/.stCommitMsg";
            };
            tag.forcesignannotated = false;
            credential.helper = "osxkeychain";
          };
        };

        # Shell configuration
        programs.zsh = {
          enable = true;
          shellAliases = {
            ll = "ls -a";
          };
          initExtra = ''
            # SDKMAN initialization
            if [ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
              source "$HOME/.sdkman/bin/sdkman-init.sh"
            fi
          '';
        };
      };

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Andrews-MacBook
    darwinConfigurations."Andrews-MacBook" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        inputs.home-manager.darwinModules.home-manager
      ];
    };
  };
}
