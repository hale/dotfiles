# Phil's Dotfiles

A fully nixified macOS configuration using [nix-darwin](https://github.com/LnL7/nix-darwin) and [home-manager](https://github.com/nix-community/home-manager).

## What's Included

- **Terminal**: Alacritty with base16-default-dark theme
- **Editor**: Neovim with LSP support for TypeScript, Python, Ruby, and Rust
- **Shell**: Zsh with Prezto framework and pure prompt
- **Multiplexer**: Tmux with vim-style navigation
- **Development Tools**: Git, ripgrep, fzf, jq, htop, bun, and more
- **Fonts**: Iosevka Nerd Font
- **macOS Settings**: Fast key repeat, Caps Lock → Escape, and more

## Installation

### Prerequisites

Fresh macOS installation

### Steps

1. **Install Nix** via Determinate Systems installer (with upstream Nix, not their fork):
   ```bash
   curl -fsSL https://install.determinate.systems/nix | sh -s -- install
   ```
   **Important**: This installs upstream Nix, which is required for nix-darwin to work properly. Do not use Determinate Systems' forked version.

2. **Clone this repository**:
   ```bash
   git clone https://github.com/hale/dotfiles.git ~/.dotfiles
   ```

3. **Run nix-darwin**:
   ```bash
   sudo nix run nix-darwin -- switch --flake ~/.dotfiles/nix-darwin-config
   ```

## Usage

After installation, manage your system with:

```bash
# Apply configuration changes
darwin-rebuild switch --flake ~/.dotfiles/nix-darwin-config

# Update flake inputs
nix flake update --flake ~/.dotfiles/nix-darwin-config
```

## Key Features

### Shell Functions
- `tat` - Smart tmux session management
- `trash` - Move files to trash instead of deleting
- `fr` - Fuzzy search command history
- `fe` - Fuzzy file opener
- `fco` - Fuzzy git branch checkout

### Aliases
- Git shortcuts (`g`, `ga`, `gc`, `gp`, etc.)
- `vim`/`vi` → `nvim`
- `tm` → `tmux -2`
- `t` → `tree`

## Structure

Everything is managed through `nix-darwin-config/flake.nix`:
- System packages
- User packages via home-manager
- Shell configuration (zsh/prezto)
- Application configs (alacritty, tmux, neovim, git)
- macOS system defaults