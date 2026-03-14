{ pkgs, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
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
        vim = "nvim";
        v = "nvim";
        cla = "ollama launch claude --model kimi-k2.5:cloud";
      };
      initExtra = ''
        # SDKMAN initialization
        if [ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
          source "$HOME/.sdkman/bin/sdkman-init.sh"
        fi
      '';
    };
  };
}
