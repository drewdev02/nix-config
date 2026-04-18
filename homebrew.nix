{ ... }:
{
  # Homebrew integration
  homebrew.enable = true;

  homebrew.taps = [
    "sdkman/tap"
    "mobile-dev-inc/tap"
    "oven-sh/bun"
  ];

  homebrew.brews = [
    "go"            # Go programming language
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
    "mobile-dev-inc/tap/maestro"  # Mobile UI testing framework
    "oven-sh/bun/bun"  # Bun runtime
    "sops"          # Secrets management tool
    "age"           # Age encryption tool
    "direnv"        # Directory-based environment variable manager
  ];

  homebrew.casks = [
    # "zed"        # Zed editor (comentado)
    "claude-code"   # Claude Code CLI
    "lens"          # Kubernetes IDE
    "tower"         # Git client
    "openvpn-connect"
    "jdownloader"   # Download manager
  ];

  homebrew.masApps = {
   # "Bitwarden" = 1352778147;
  };

  homebrew.onActivation = {
    cleanup = "none";
  };
}
