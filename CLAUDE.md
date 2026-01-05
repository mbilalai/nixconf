# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a modular NixOS/nix-darwin configuration flake that supports both Linux (NixOS) and macOS systems. The configuration uses a shared modular architecture with platform-specific host configurations.

## System Architecture

### Key Structure
- `flake.nix`: Main flake configuration defining inputs, outputs, and system configurations
- `hosts/`: Host-specific configurations
  - `alpha/`: Linux NixOS configuration (x86_64-linux)
  - `macbook/`: macOS darwin configuration (aarch64-darwin)
- `modules/`: Shared system-level modules
  - `system/`: Core system configurations and packages
  - `desktop/`: Desktop environment configurations (COSMIC DE)
- `home/`: Home Manager configurations
  - `common/`: Shared user-level configurations (packages, git, etc.)

### Configuration Flow
1. `flake.nix` defines system outputs for NixOS and darwin
2. Host configurations import system modules and Home Manager
3. Home Manager imports common user configurations
4. System uses unstable package overlay for bleeding-edge software

## Common Development Commands

### Building Configurations
```bash
# Build NixOS configuration (Linux host 'alpha')
sudo nixos-rebuild switch --flake .#alpha

# Build darwin configuration (macOS host 'macbook') 
darwin-rebuild switch --flake .#macbook

# Test configuration without switching
sudo nixos-rebuild test --flake .#alpha
darwin-rebuild check --flake .#macbook
```

### Development Workflow
```bash
# Update flake inputs (includes nixos-cosmic updates)
nix flake update

# Check flake syntax
nix flake check

# Format Nix files
nix fmt

# Enter development shell with flake packages
nix develop
```

### COSMIC Desktop Updates
This configuration uses the `nixos-cosmic` flake for COSMIC 1.0 stable:
- **Source**: `github:lilyinstarlight/nixos-cosmic`
- **Cache**: `cosmic.cachix.org` for prebuilt binaries
- **Updates**: Run `nix flake update` to get latest COSMIC releases
- **Features**: Native Wayland, COSMIC Greeter, stable application suite

### Home Manager Operations
```bash
# Rebuild Home Manager configuration
home-manager switch --flake .#alpha  # or #macbook

# Check Home Manager configuration
home-manager build --flake .#alpha
```

## Package Management

### Adding System Packages
- Edit `modules/system/packages.nix` for system-wide packages
- Packages are installed via `environment.systemPackages`
- Includes development tools: rust-analyzer, cargo, rustc, rustfmt, clippy
- Language servers: nil (Nix), taplo (TOML)
- Authentication support: gnome-keyring, libsecret for app sign-in

### Adding User Packages  
- Edit `home/common/packages.nix` for user-specific packages
- Packages are installed via `home.packages`

### Using Unstable Packages
Unstable packages are available via the `unstable` overlay:
```nix
# In package lists, use:
pkgs.unstable.package-name
```

### Development Tools Installed
- **Rust toolchain**: cargo, rustc, rustfmt, clippy, rust-analyzer
- **Build tools**: gcc, cmake, pkg-config
- **Language servers**: nil, taplo, rust-analyzer
- **Authentication**: gnome-keyring (enabled for Zed sign-in)
- **Media tools**: ffmpeg, imagemagick

## Platform-Specific Notes

### NixOS (alpha)
- **COSMIC DE 1.0 STABLE**: Latest stable release via nixos-cosmic flake
- **Display setup**: COSMIC Greeter (native), Wayland-only environment
- **XDG portals**: COSMIC-specific portal with GTK fallback
- **COSMIC apps**: Complete stable application suite included
- **Optimizations**: Native Wayland, hardware acceleration, performance tuned
- **Authentication**: Fingerprint support for COSMIC greeter
- **Services**: VirtualBox, Docker, Mullvad VPN, and Tailscale
- **Hardware config**: `hosts/alpha/hardware-configuration.nix`

### macOS (macbook)
- Uses nix-darwin for system management
- Homebrew integration enabled
- Fish shell configured as default
- Home Manager handles user-level configurations

## Configuration Guidelines

### State Versions
- NixOS state version: 25.05
- Home Manager state version: 25.05
- Darwin state version: 4

### User Configuration
- Default user: `alpha`
- Default shell: Fish
- Git editor: Helix
- Git user configured in `home/common/git.nix`

### Modular Design
- Keep host-specific settings in `hosts/`
- Share common configurations via `modules/` and `home/common/`
- Use Home Manager for user-level dotfiles and applications
- System-level services and hardware in system modules