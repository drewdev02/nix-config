{ config, pkgs, ... }: {
  # Git configuration
  programs.git = {
    enable = true;

    # User identity (change these)
    userName = "Your Name";
    userEmail = "your.email@example.com";

    # Git aliases
    aliases = {
      co = "checkout";
      br = "branch";
      ci = "commit";
      st = "status";
      lg = "log --oneline --graph --decorate";
    };

    # Extra config
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "vim";
    };
  };

  # Git credential helper (macOS Keychain)
  # programs.git.credentialHelper = "osxkeychain";

  # Git signing with GPG
  # programs.git.signing = {
  #   key = "YOUR_GPG_KEY_ID";
  #   signByDefault = true;
  # };
}
