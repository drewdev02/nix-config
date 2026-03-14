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
      cla = "ollama launch claude --model kimi-k2.5:cloud";
    };

    initContent = ''
      # SDKMAN initialization
      # SDKMAN is a tool for managing parallel versions of multiple SDKs
      if [ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
        source "$HOME/.sdkman/bin/sdkman-init.sh"
      fi
    '';
  };
}
