# nix-darwin Configuration

This directory contains the [nix-darwin](https://github.com/nix-darwin/nix-darwin) configuration for managing macOS system configuration with Nix.

## Structure

```
/etc/nix-darwin/
├── flake.nix              # Main flake entry point
├── flake.lock             # Lock file for dependencies
├── system.nix             # System-level configuration
├── users.nix              # User definitions
├── homebrew.nix           # Homebrew packages and casks
├── home-manager-module.nix # Home Manager module setup
└── home/                  # User-specific configuration
    ├── default.nix        # Entry point for user config
    ├── git.nix            # Git configuration
    ├── zsh.nix            # Zsh shell configuration
    └── packages.nix       # User packages
```

### Modules

| File | Description |
|------|-------------|
| `flake.nix` | Main flake with inputs and darwinSystem definition. Defines `pkgs-unstable` once and passes it to all modules |
| `system.nix` | Nix settings, system packages, dock, platform, ollama service |
| `users.nix` | User account definitions |
| `homebrew.nix` | Homebrew taps, brews, casks, MAS apps |
| `home-manager-module.nix` | Home Manager module setup with `extraSpecialArgs` |
| `home/default.nix` | Entry point for user configuration |
| `home/git.nix` | Git configuration with managed gitignore and commit template |
| `home/zsh.nix` | Zsh aliases and init scripts |
| `home/packages.nix` | User-specific packages |

## Design Decisions

### Explicit Package References
This configuration avoids `with pkgs;` to make dependencies explicit and easier to track.

### Single Definition of Unstable Packages
`pkgs-unstable` is defined once in `flake.nix` and passed via `specialArgs` to all modules, avoiding repetition and potential inconsistencies.

### Modular Home Manager Configuration
User configuration is split into focused modules (git, zsh, packages) for better maintainability.

### Managed Configuration Files
Git ignore and commit templates are managed by Nix and written to the Nix store, eliminating external file dependencies.

## Setup

```bash
# Create and set permissions
sudo mkdir -p /etc/nix-darwin
sudo chown $(id -nu):$(id -ng) /etc/nix-darwin
cd /etc/nix-darwin

# Initialize flake (choose your Nixpkgs channel)
# For unstable:
nix flake init -t nix-darwin/master

# For stable 25.05:
nix flake init -t nix-darwin/nix-darwin-25.05

# Update hostname in flake.nix
sed -i '' "s/simple/$(scutil --get LocalHostName)/" flake.nix
```

## Installation

Unlike NixOS, nix-darwin does not have an installer. You can just run `darwin-rebuild switch` to install nix-darwin. As `darwin-rebuild` won't be installed in your PATH yet, use:

```bash
# For Nixpkgs unstable:
sudo nix run nix-darwin/master#darwin-rebuild -- switch

# For Nixpkgs 25.05:
sudo nix run nix-darwin/nix-darwin-25.05#darwin-rebuild -- switch
```

After installation, `darwin-rebuild` will be available in your PATH.

## Usage

### Apply configuration

```bash
darwin-rebuild switch --flake /etc/nix-darwin
```

### Build without applying

```bash
darwin-rebuild build --flake /etc/nix-darwin
```

### Working with untracked files

Nix flakes only access files tracked by git. When modifying configuration files:

```bash
# Option 1: Stage files (no commit required)
git add -A
darwin-rebuild switch --flake /etc/nix-darwin --impure

# Option 2: Use path: reference for local testing
darwin-rebuild switch --flake path:/etc/nix-darwin#Andrews-MacBook --impure
```

## Resources

- [nix-darwin GitHub](https://github.com/nix-darwin/nix-darwin)
- [Nixpkgs Options Search](https://search.nixos.org/options)
- [Darwin Options](https://github.com/nix-darwin/nix-darwin/blob/master/modules/darwin.nix)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.html)
