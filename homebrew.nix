{
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
    "watchman"
    "cntlm"
    "opencode"
    "scrcpy"
    "gh"
    "cloudflared"
    "cocoapods"
    "neovim"
  ];
  homebrew.casks = [
    #"zed"
    "claude-code"
    "tower"
  ];
  homebrew.masApps = {
    "Bitwarden" = 1352778147;
  };
  homebrew.onActivation = {
    cleanup = "none";
  };
}
