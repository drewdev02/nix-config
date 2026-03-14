{ pkgs, ... }:
let
  # Git ignore global file managed by Nix
  gitignoreGlobal = pkgs.writeText "gitignore-global" ''
    # macOS
    .DS_Store
    .AppleDouble
    .LSOverride
    Icon
    ._*
    .DocumentRevisions-V100
    .fseventsd
    .Spotlight-V100
    .TemporaryItems
    .Trashes
    .VolumeIcon.icns
    .com.apple.timemachine.donotpresent

    # IDE
    .idea/
    .vscode/
    *.swp
    *.swo
    *~

    # Logs
    *.log
    npm-debug.log*
    yarn-debug.log*
    yarn-error.log*

    # Dependencies
    node_modules/
    .pnp
    .pnp.js

    # Build outputs
    dist/
    build/
    .next/
    out/

    # Environment files
    .env
    .env.local
    .env.*.local
  '';

  # Git commit message template
  commitTemplate = pkgs.writeText "commit-template" ''
    # <type>: <subject>
    #
    # <body>
    #
    # <footer>
  '';
in
{
  programs.git = {
    enable = true;
    userName = "Andrey Rodriguez";
    userEmail = "andrey.rgz.2016@gmail.com";

    extraConfig = {
      core = {
        autocrlf = "input";
        excludesfile = "${gitignoreGlobal}";
        filemode = true;
        ignorecase = true;
        precomposeunicode = true;
      };
      # NOTE: sslverify disabled - may be needed for corporate certs
      # Consider using sslCAInfo instead for custom certificates
      http.sslverify = false;
      gpg = {
        format = "openpgp";
        program = "gpg";
      };
      commit = {
        gpgsign = false;
        template = "${commitTemplate}";
      };
      tag.forcesignannotated = false;
      credential.helper = "osxkeychain";
    };
  };
}
