{ ... }:
{
  programs.zsh = {
    enable = true;

    shellAliases = {
      # List all files including hidden
      ll = "ls -la";

      # Neovim shortcuts
      vim = "nvim";
      v = "nvim";

      # Claude Code with Ollama
      claudio = "ccr code";

      # Rebuild system configuration with darwin-rebuild
      dr="sudo darwin-rebuild switch";
    };

    initContent = ''
      # SDKMAN initialization
      # SDKMAN is a tool for managing parallel versions of multiple SDKs
      if [ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
        source "$HOME/.sdkman/bin/sdkman-init.sh"
      fi

      export SSH_AUTH_SOCK=/Users/Andrew/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock
      export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt
    '';
  };
}
