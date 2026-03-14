{ ... }:
{
  # Homebrew integration
  homebrew.enable = true;

  homebrew.taps = [
    "sdkman/tap"
  ];

  homebrew.brews = [
    "fnm"           # Fast Node Manager
    "uv"            # Python package manager
    "mas"           # Mac App Store CLI
    "sdkman/tap/sdkman-cli"  # SDK manager for JVM
    "qwen-code"     # Qwen code assistant
    "watchman"      # File watching service
    "cntlm"         # NTLM proxy
    "opencode"      # OpenCode CLI
    "scrcpy"        # Android screen mirroring
    "gh"            # GitHub CLI
    "cloudflared"   # Cloudflare tunnel
    "cocoapods"     # iOS dependency manager
    "neovim"        # Modern Vim
  ];

  homebrew.casks = [
    # "zed"        # Zed editor (comentado)
    "claude-code"   # Claude Code CLI
    "tower"         # Git client
  ];

  homebrew.masApps = {
    "Bitwarden" = 1352778147;
  };

  homebrew.onActivation = {
    cleanup = "none";
  };
}
