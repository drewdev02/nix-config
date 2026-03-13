{ config, pkgs, ... }: {
  # Development tools and languages

  # Core development tools
  environment.systemPackages = with pkgs; [
    # Version control
    git

    # Text editors / CLI
    neovim
    ripgrep
    fd
    jq
    yq

    # Build tools
    gnumake
    cmake
    just

    # HTTP / API tools
    curl
    wget
    httpie

    # Database tools
    postgresql
    mysql

    # Container tools
    docker-compose
  ];

  # Language toolchains (uncomment what you need)
  # Node.js
  # environment.systemPackages = [ pkgs.nodejs_20 pkgs.yarn pkgs.pnpm ];

  # Python
  # environment.systemPackages = [ pkgs.python311 pkgs.pip ];

  # Rust
  # environment.systemPackages = [ pkgs.rustup ];

  # Go
  # environment.systemPackages = [ pkgs.go ];

  # Java
  # environment.systemPackages = [ pkgs.jdk17 pkgs.maven ];

  # Ruby
  # environment.systemPackages = [ pkgs.ruby pkgs.bundler ];

  # Nix development
  # environment.systemPackages = [ pkgs.nil pkgs.nixfmt-classic pkgs.deadnix ];
}
