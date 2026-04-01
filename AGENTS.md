# AGENTS.md — nix-darwin Configuration

## Build & Validation Commands

```bash
# Apply configuration to system
darwin-rebuild switch --flake /etc/nix-darwin

# Build without applying (dry-run)
darwin-rebuild build --flake /etc/nix-darwin

# Check flake integrity
nix flake check

# Format Nix files (if nixfmt available)
nix fmt

# Update flake inputs
nix flake update

# Show available outputs
nix flake show

# Test with untracked files (impure mode)
darwin-rebuild switch --flake path:/etc/nix-darwin#Andrews-MacBook --impure
```

## Code Style Guidelines

### Imports & Module Structure
- Use `imports = [ ./file.nix ];` for modular configuration
- Entry point is `flake.nix`, which calls `darwinSystem` with modules array
- Home Manager modules go in `home/` directory with `default.nix` as entry
- System modules: `system.nix`, `users.nix`, `homebrew.nix`, `home-manager-module.nix`

### Function Parameters & Arguments
```nix
# Destructure pkgs and special args in module functions
{ pkgs, pkgs-unstable, config, ... }:

# Pass special args via flake outputs
specialArgs = { inherit inputs pkgs-unstable; };
```

### Package References (IMPORTANT)
- **NEVER use `with pkgs;`** — always use explicit `pkgs.packageName` references
- This makes dependencies explicit and easier to track
- Use `pkgs-unstable` for packages not available in stable channel

```nix
# Good
environment.systemPackages = [ pkgs.git pkgs.tmux pkgs-unstable.ollama ];

# Bad
with pkgs; [ git tmux ollama ]
```

### Formatting & Indentation
- **2-space indentation** (Nix standard)
- **Trailing commas** in lists and attribute sets
- Align attribute values for readability
- Maximum line length: ~100 characters

```nix
{
  environment.systemPackages = [
    pkgs.git
    pkgs.tmux
    pkgs-unstable.ollama
  ];

  services.someService = {
    enable = true;
    port = 8080;
  };
}
```

### Local Definitions (let-in)
- Use `let ... in` blocks for reusable values within a module
- Keep let bindings close to their usage
- Document complex derivations

```nix
{ pkgs, ... }:
let
  configFile = pkgs.writeText "config" ''
    key = value
  '';
in
{
  environment.etc."app/config" = {
    source = configFile;
  };
}
```

### Naming Conventions
- **Files**: `lowercase.nix` (e.g., `git.nix`, `zsh.nix`)
- **Variables**: `camelCase` (e.g., `pkgsUnstable`, `configFile`)
- **Attributes**: Follow NixOS/nix-darwin schema (kebab-case for options)
- **System names**: Match hostname from `scutil --get LocalHostName`

### Error Handling & Comments
- Use `#` for single-line comments
- Add `# NOTE:` for important warnings or caveats
- Document non-obvious configuration decisions
- Comment out (don't delete) experimental configurations

```nix
# NOTE: sslverify disabled for corporate environment
# Consider using sslCAInfo for custom certificates
http.sslverify = false;

#launchd.user.agents.ollama = { ... };  # Disabled: using alternative
```

### State Version
- Set `system.stateVersion` and `home.stateVersion` appropriately
- Match the Nixpkgs version (e.g., `"25.05"`)
- Do not change after initial setup unless migrating

### Homebrew Integration
- List taps, brews, casks separately
- Comment out unused entries (don't delete)
- Use full tap paths (e.g., `"oven-sh/bun"`)

```nix
homebrew.taps = [ "oven-sh/bun" ];
homebrew.brews = [ "go" "fnm" ];
homebrew.casks = [ "claude-code" ];
```

### Git & Flakes Workflow
- All files must be git-tracked for flakes to work
- Stage changes with `git add` before rebuilding
- Use `--impure` flag for local testing with uncommitted changes
- Commit message format: `<type>: <subject>` (conventional commits)

### Common Patterns

**Conditional Configuration:**
```nix
{ config, lib, ... }:
{
  services.foo = lib.mkIf config.services.bar.enable {
    # ...
  };
}
```

**Extending Lists:**
```nix
environment.systemPackages = [
  pkgs.git
] ++ (with pkgs.python3Packages; [ pip setuptools ]);
```

**Managed Files:**
```nix
let
  configFile = pkgs.writeText "name" "content";
in
{
  environment.etc."app/config" = {
    source = configFile;
    mode = "0644";
  };
}
```

## Resources
- [nix-darwin Options](https://github.com/nix-darwin/nix-darwin/blob/master/modules/darwin.nix)
- [Nixpkgs Options Search](https://search.nixos.org/options)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.html)
- [Nix Pills](https://nixos.org/guides/nix-pills/)
