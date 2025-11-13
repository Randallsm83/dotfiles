# Dotfiles

Modern, cross-platform dotfile management using [chezmoi](https://www.chezmoi.io/) with support for Windows, WSL2, Linux, and macOS.

## ✨ Features

- **One-command setup** - Bootstrap new machines in under 10 minutes
- **Cross-platform** - Single source of truth for all platforms
- **Template-driven** - Platform-specific configs with Go templates
- **XDG compliant** - Consistent directory structure across all platforms
- **Automated installation** - Packages, runtimes, and tools installed automatically
- **Modern tooling** - mise, scoop, starship, neovim, wezterm
- **Theme consistency** - spaceduck/onedark color schemes everywhere

## 🚀 Quick Start

### Windows (PowerShell)

```powershell
# One-command bootstrap (when published)
iwr -useb https://raw.githubusercontent.com/Randallsm83/dotfiles/main/bootstrap.ps1 | iex

# Or clone and run locally
git clone https://github.com/Randallsm83/dotfiles.git
cd dotfiles
.\bootstrap.ps1
```

### Unix (Linux/WSL/macOS)

```bash
# One-command bootstrap (when published)
curl -fsSL https://raw.githubusercontent.com/Randallsm83/dotfiles/main/setup.sh | bash

# Or clone and run locally
git clone https://github.com/Randallsm83/dotfiles.git
cd dotfiles
chmod +x setup.sh
./setup.sh
```

### What Gets Installed

The bootstrap scripts will:

1. ✅ Install chezmoi (scoop/mise/curl)
2. ✅ Clone this dotfiles repository
3. ✅ Apply all configurations (with platform-specific templates)
4. ✅ Install package managers (scoop/mise/homebrew)
5. ✅ Install CLI tools (git, neovim, starship, ripgrep, etc.)
6. ✅ Install language runtimes (node, python, ruby, perl, go, rust, lua)
7. ✅ Configure environment (XDG paths, shell integrations)
8. ✅ Set up SSH agent (1Password integration)

## 📂 Repository Structure

```
.local/share/chezmoi/          # Chezmoi source directory
├── .chezmoi.toml.tmpl         # Chezmoi configuration (platform detection, XDG paths)
├── .chezmoidata.yaml          # User data and package lists
├── .chezmoiignore             # Platform-specific file exclusions
├── .chezmoitemplates/         # Reusable template snippets
│   ├── detect-package-manager
│   ├── xdg-paths
│   └── platform-conditional
│
├── dot_config/                # Cross-platform configs (~/.config/)
│   ├── git/
│   ├── nvim/
│   ├── wezterm/
│   ├── starship/
│   ├── mise/
│   ├── bat/
│   └── ...
│
├── Documents/                 # Windows-specific
│   └── PowerShell/
│       └── Microsoft.PowerShell_profile.ps1.tmpl
│
├── dot_zshrc.tmpl             # Unix shell config
├── dot_zshenv.tmpl
│
├── .chezmoiscripts/           # Auto-run scripts
│   ├── run_once_before_00_install_chezmoi.ps1.tmpl
│   ├── run_once_before_00_install_chezmoi.sh.tmpl
│   ├── run_once_install_packages_windows.ps1.tmpl
│   └── run_once_install_packages_unix.sh.tmpl
│
├── bootstrap.ps1              # Windows entry point
├── setup.sh                   # Unix entry point
└── README.md                  # This file
```

### Chezmoi Naming Conventions

| Source File | Target Location | Notes |
|-------------|-----------------|-------|
| `dot_gitconfig` | `~/.gitconfig` | Dotfile (prefix `dot_`) |
| `dot_gitconfig.tmpl` | `~/.gitconfig` | Templated dotfile |
| `dot_config/nvim/init.lua` | `~/.config/nvim/init.lua` | Nested config |
| `Documents/PowerShell/profile.ps1` | `~/Documents/PowerShell/profile.ps1` | Non-dotfile |
| `executable_dot_local/bin/script.sh` | `~/.local/bin/script.sh` | Executable |

## 🖥️ Platform Support

### Windows 11
- **Package managers**: scoop (CLI tools), winget (GUI apps), mise (runtimes)
- **Shell**: PowerShell 7+ (pwsh)
- **Terminals**: WezTerm (primary), Windows Terminal, Warp
- **XDG paths**: `%USERPROFILE%\.config`, `%USERPROFILE%\.local\share`, etc.
- **Developer Mode**: Required for symlinks

### WSL2 (Ubuntu/Arch)
- **Package manager**: mise (via cargo)
- **Shell**: zsh
- **Terminals**: WezTerm, Warp (via Windows)
- **XDG paths**: `~/.config`, `~/.local/share`, etc.
- **Integration**: Native 1Password SSH agent integration

### Linux (Native)
- **Package manager**: mise (primary), apt/dnf/pacman (bootstrap)
- **Shell**: zsh
- **Terminals**: WezTerm, Warp
- **XDG paths**: Standard `~/.config`, `~/.local/share`, etc.

### macOS
- **Package managers**: homebrew (bootstrap), mise (preferred)
- **Shell**: zsh
- **Terminals**: WezTerm, Warp
- **XDG paths**: `~/.config`, `~/.local/share`, etc.

## 📦 Package Management Strategy

### Windows
- **scoop**: CLI tools (git, neovim, starship, ripgrep, bat, fd, fzf, eza, vivid, btop, delta, gh, lazygit, zoxide, make, zig, jq, yq, curl, wget)
- **winget**: GUI apps (Git.Git w/GCM, wez.wezterm, Microsoft.PowerShell, WindowsTerminal, VS Code, 7zip, Warp)
- **mise**: Language runtimes only (node, python, ruby, perl, go, rust, lua, bun, deno)

### Linux/WSL
- **mise**: Everything (CLI tools via cargo + language runtimes)
- **apt/dnf/pacman**: Bootstrap only (git, build-essential) when sudo available

### macOS
- **homebrew**: GUI apps and some CLI tools
- **mise**: Preferred for CLI tools and all language runtimes

## 🎨 Theme & Styling

### Colors
- **Primary theme**: spaceduck (vivid, eza)
- **Secondary themes**: onedark (neovim, starship), gruvbox-material (wezterm)
- **Style**: Dark themes optimized for relatively dark environments
- **Key colors**:
  - Purples: `#b3a1e6`, `#c678dd`
  - Pinks: `#ce6f8f`
  - Greens: `#5ccc96`, `#98c379`
  - Oranges: `#e39400`, `#d19965`
  - Blues: `#00a3cc`, `#61afef`
  - Cyans: `#42b3c2`, `#56b6c2`
  - Yellows: `#f2ce00`, `#e5c07b`

### Fonts
- **Primary**: Hack Nerd Font
- **Fallback**: Fira Code Nerd Font (with ligatures)
- **Also installed**: JetBrains Mono, Cascadia Code
- **Emoji**: Noto Color Emoji
- **Symbols**: Symbols Nerd Font Mono

## ⚙️ Configuration

### Customizing User Data

Edit `.chezmoidata.yaml` to customize:

```yaml
user:
  name: "Your Name"
  email: "your.email@example.com"
  github: "yourusername"
```

### Package Lists

Add/remove packages in `.chezmoidata.yaml`:

```yaml
scoop_packages:
  - your-package-here

winget_packages:
  - Publisher.AppName

mise_runtimes:
  python: "3.12"
  node: "lts"
```

### Feature Toggles

Control what gets installed:

```yaml
features:
  install_packages: true
  install_runtimes: true
  setup_ssh: true
  setup_1password: true
```

## 🔧 Maintenance

### Daily Workflow

```bash
# Edit a config file
chezmoi edit ~/.config/nvim/init.lua

# Preview changes
chezmoi diff

# Apply changes
chezmoi apply

# Commit and push
chezmoi cd
git add .
git commit -m "Update nvim config"
git push
```

### Adding New Files

```bash
# Add existing file to chezmoi
chezmoi add ~/.config/newapp/config.toml

# Add as template (for platform-specific configs)
chezmoi add --template ~/.gitconfig

# Edit and apply
chezmoi edit --apply ~/.config/newapp/config.toml
```

### Updating on Other Machines

```bash
# Pull latest changes and apply
chezmoi update

# Or manually
chezmoi cd
git pull
chezmoi apply
```

### Re-running Installation Scripts

```bash
# Clear script state to force re-run
chezmoi state delete-bucket --bucket=scriptState

# Apply again (will run scripts)
chezmoi apply
```

## 🐛 Troubleshooting

### Windows: Execution Policy Error

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Windows: Scoop Installation Fails

```powershell
# Install via winget instead
winget install twpayne.chezmoi
```

### Unix: Permission Denied

```bash
# Make setup script executable
chmod +x setup.sh
```

### Chezmoi: Template Errors

```bash
# Check template syntax
chezmoi execute-template < .chezmoi.toml.tmpl

# Dry-run to see what would be applied
chezmoi apply --dry-run --verbose
```

### Package Installation Fails

```bash
# Windows: Update scoop
scoop update

# Unix: Update mise
mise self-update
mise plugins update
```

### SSH Agent Not Working

**Windows:**
1. Ensure 1Password SSH agent is enabled
2. Check pipe exists: `\\.\pipe\openssh-ssh-agent`
3. Verify Git config points to Windows OpenSSH

**Unix:**
1. Ensure 1Password SSH agent is running
2. Check socket exists: `~/.1password/agent.sock`
3. Verify SSH_AUTH_SOCK environment variable

## 📚 Essential Commands

### Chezmoi

```bash
# See what would change
chezmoi apply --dry-run --verbose

# Show differences
chezmoi diff

# Apply changes
chezmoi apply

# Edit file
chezmoi edit ~/.gitconfig

# Edit and apply immediately
chezmoi edit --apply ~/.gitconfig

# Navigate to source directory
chezmoi cd

# Add file to chezmoi
chezmoi add ~/.config/app/config.toml

# Update from repository
chezmoi update

# Execute template for testing
chezmoi execute-template < dot_gitconfig.tmpl
```

### Package Managers

```powershell
# Windows: scoop
scoop search <package>
scoop install <package>
scoop update *

# Windows: winget
winget search <app>
winget install <app>
winget upgrade --all
```

```bash
# Unix/macOS: mise
mise use -g <tool>@<version>
mise install
mise upgrade

# macOS: homebrew
brew search <formula>
brew install <formula>
brew upgrade
```

## 🔐 Security

- **SSH keys**: Managed by 1Password SSH agent (not stored in dotfiles)
- **API tokens**: Use 1Password CLI integration (not stored in dotfiles)
- **Secrets**: Never commit sensitive data to this repository
- **`.chezmoiignore`**: Excludes sensitive files from being managed

## 📖 Resources

- **Chezmoi documentation**: https://www.chezmoi.io/
- **User guide**: https://www.chezmoi.io/user-guide/
- **Template reference**: https://www.chezmoi.io/user-guide/templating/
- **Command reference**: https://www.chezmoi.io/reference/commands/

## 🤝 Contributing

This is a personal dotfiles repository, but feel free to:
- Fork for your own use
- Suggest improvements via issues
- Share interesting configurations

## 📄 License

MIT License - Feel free to use and modify as needed.

---

**Built with** [chezmoi](https://www.chezmoi.io/) • **Inspired by** the XDG Base Directory Specification • **Powered by** mise, scoop, and modern CLI tools
