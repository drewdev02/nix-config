# nix-darwin Configuration

This directory contains the [nix-darwin](https://github.com/nix-darwin/nix-darwin) configuration for managing macOS system configuration with Nix.

## Structure

```
/etc/nix-darwin/
├── flake.nix              # Main flake entry point
├── system/                # System-level configuration
│   └── default.nix
├── users/                 # User definitions
│   └── default.nix
├── homebrew/              # Homebrew packages and casks
│   └── default.nix
└── home-manager/          # User environment configuration
    ├── default.nix        # Home Manager entry point
    └── Andrew/            # Per-user configurations
        └── default.nix
```

### Modules

| Module | Description |
|--------|-------------|
| `system/` | Nix settings, system packages, dock, platform |
| `users/` | User account definitions |
| `homebrew/` | Homebrew taps, brews, casks, MAS apps |
| `home-manager/` | User-specific config (git, zsh, packages) |

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

### Add new user configuration

1. Create directory: `home-manager/<username>/default.nix`
2. Add configuration following the pattern in `home-manager/Andrew/`
3. Import in `home-manager/default.nix`

## Resources

- [nix-darwin GitHub](https://github.com/nix-darwin/nix-darwin)
- [Nixpkgs Options Search](https://search.nixos.org/options)
- [Darwin Options](https://github.com/nix-darwin/nix-darwin/blob/master/modules/darwin.nix)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.html)
