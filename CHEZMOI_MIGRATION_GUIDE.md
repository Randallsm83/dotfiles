# Chezmoi Migration Guide

## Overview

This guide walks you through migrating your GNU Stow-based dotfiles to **chezmoi** for modern, template-driven dotfile management with rapid VM/machine provisioning.

**Goal:** Enable one-command setup of identical development environments across Windows, WSL2, Linux, and macOS.

---

## Why Chezmoi?

✅ **Better templating** - Platform-specific configs with powerful Go templates  
✅ **Cross-platform** - Single source of truth for all platforms  
✅ **Modern tooling** - Built-in diff, merge, and secrets management  
✅ **Rapid provisioning** - Spin up new machines in minutes  
✅ **Active development** - Well-maintained with great documentation

---

## Migration Strategy

### Key Decisions

- ✅ **New repository** - Start fresh in a separate repo
- ✅ **Clean commit history** - No migration of old commits
- ✅ **Keep existing dotfiles** - Parallel operation during transition
- ✅ **Scoop for chezmoi** - Install via scoop (Windows CLI tool manager)
- ✅ **Automated setup** - Bootstrap scripts install chezmoi automatically

### Repository Structure

**Old (Stow-based):**
```
C:\Users\Randall\.config\dotfiles\
├── .stowrc
├── git/dot-config/git/
├── nvim/dot-config/nvim/
├── windows/bootstrap.ps1
└── [40+ config directories]
```

**New (Chezmoi-based):**
```
C:\Users\Randall\.local\share\chezmoi\  # Chezmoi default location
├── .chezmoi.toml.tmpl
├── .chezmoidata.yaml
├── .chezmoiignore
├── .chezmoitemplates/
├── dot_gitconfig.tmpl
├── dot_config/
│   ├── nvim/
│   ├── wezterm/
│   ├── starship/
│   └── mise/config.toml.tmpl
├── Documents/PowerShell/Microsoft.PowerShell_profile.ps1.tmpl  # Windows
├── dot_zshrc.tmpl  # Unix
├── .chezmoiscripts/
│   ├── run_once_before_00_install_chezmoi.ps1.tmpl  # Windows
│   └── run_once_before_00_install_chezmoi.sh.tmpl   # Unix
└── README.md
```

---

## Quick Start: First Steps

### 1. Install Chezmoi (Manual - for testing)

**Windows (via scoop):**
```powershell
scoop install chezmoi
```

**Windows (via winget - fallback):**
```powershell
winget install twpayne.chezmoi
```

**Unix (via mise - preferred):**
```bash
mise use -g chezmoi
```

**Unix (via homebrew - fallback):**
```bash
brew install chezmoi
```

**Unix (via curl - last resort):**
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
```

### 2. Create Development Directory

Don't initialize in the default location yet - use a dev directory first:

```powershell
# Windows
mkdir C:\Users\Randall\chezmoi-dev
cd C:\Users\Randall\chezmoi-dev
chezmoi init --working-tree .
```

```bash
# Unix
mkdir ~/chezmoi-dev
cd ~/chezmoi-dev
chezmoi init --working-tree .
```

### 3. Initialize Git Repository

```bash
git init
git add .
git commit -m "Initial chezmoi structure"
```

---

## Migration Checklist

Follow the TODO list created in Warp. Here's the high-level workflow:

### Phase 1: Foundation (Steps 1-2)
- [ ] Create chezmoi repository structure
- [ ] Create bootstrap scripts with automatic chezmoi installation

### Phase 2: Core Configs (Steps 3-6)
- [ ] Migrate cross-platform configs (git, neovim, wezterm, starship)
- [ ] Create Windows-specific configs (PowerShell, Windows Terminal)
- [ ] Create Unix-specific configs (zsh, shell integrations)
- [ ] Migrate package management (scoop.json, mise config.toml)

### Phase 3: Advanced (Steps 7-9)
- [ ] Implement secrets management (1Password integration)
- [ ] Create comprehensive documentation
- [ ] Set up chezmoi configuration and metadata

### Phase 4: Complete Migration (Steps 10-12)
- [ ] Migrate remaining 40+ config directories
- [ ] Test on Windows and prepare multi-platform tests
- [ ] Finalize and publish new repository

---

## Key Concepts

### Chezmoi Naming Conventions

| Source File (in chezmoi) | Target Location | Notes |
|--------------------------|-----------------|-------|
| `dot_gitconfig` | `~/.gitconfig` | Simple dotfile |
| `dot_gitconfig.tmpl` | `~/.gitconfig` | Templated dotfile |
| `dot_config/nvim/init.lua` | `~/.config/nvim/init.lua` | Nested config |
| `Documents/PowerShell/profile.ps1` | `~/Documents/PowerShell/profile.ps1` | Non-dotfile |
| `executable_dot_local/bin/executable_script.sh` | `~/.local/bin/script.sh` | Executable |

### Platform Detection in Templates

```go
{{- if eq .chezmoi.os "windows" }}
# Windows-specific content
{{- else if eq .chezmoi.os "darwin" }}
# macOS-specific content
{{- else }}
# Linux-specific content
{{- end }}
```

### WSL Detection

```go
{{- if eq .chezmoi.os "linux" }}
{{-   if (.chezmoi.kernel.osrelease | lower | contains "microsoft") }}
# WSL-specific content
{{-   else }}
# Native Linux content
{{-   end }}
{{- end }}
```

---

## Testing Workflow

### Dry Run (Safe)

```bash
# See what would be applied without making changes
chezmoi apply --dry-run --verbose
```

### Diff Current State

```bash
# Compare what chezmoi would change
chezmoi diff
```

### Apply Changes

```bash
# Apply all changes
chezmoi apply

# Apply specific file
chezmoi apply ~/.gitconfig
```

### Edit and Apply

```bash
# Edit a file in chezmoi and apply changes
chezmoi edit ~/.gitconfig
chezmoi apply ~/.gitconfig
```

---

## One-Command Setup (Final Goal)

Once complete, provisioning a new machine will be:

**Windows:**
```powershell
iwr -useb https://raw.githubusercontent.com/YOUR_USERNAME/chezmoi-dotfiles/main/bootstrap.ps1 | iex
```

**Unix:**
```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/chezmoi-dotfiles/main/setup.sh | bash
```

This will:
1. ✅ Install chezmoi (scoop/mise)
2. ✅ Clone dotfiles repository
3. ✅ Apply all configurations
4. ✅ Install package managers (scoop/mise)
5. ✅ Install all packages
6. ✅ Configure shell and environment
7. ✅ Ready to work in <10 minutes

---

## Resources

- **Chezmoi Docs:** https://www.chezmoi.io/
- **User Guide:** https://www.chezmoi.io/user-guide/
- **Template Reference:** https://www.chezmoi.io/user-guide/templating/
- **Command Reference:** https://www.chezmoi.io/reference/commands/

---

## Next Steps

1. Review this guide and the TODO list in Warp
2. Install chezmoi manually for testing
3. Create dev directory and initialize chezmoi
4. Start with Phase 1: Foundation
5. Incrementally migrate configs, testing as you go
6. Keep existing Stow dotfiles as backup
7. Test on fresh VM before finalizing

**Ready to begin? Start with TODO #1: Create new chezmoi repository structure**
