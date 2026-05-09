#!/usr/bin/env bash
# bootstrap.sh — single entry point for dotfiles setup
# Usage: ./bootstrap.sh
# Works on any machine; no username hardcoded anywhere.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "╔══════════════════════════════════════╗"
echo "║       dotfiles bootstrap v2.0        ║"
echo "╚══════════════════════════════════════╝"
echo ""

# ── Git user name ─────────────────────────────────────────────────────────────
# Email is intentionally NOT set here — use 'git config user.email' per repo.
# useconfigonly = true in git.nix enforces this.
GIT_CONF="$HOME/.config/git/local.conf"
if [[ -f "$GIT_CONF" ]]; then
    echo "✓ $GIT_CONF already exists — skipping name prompt"
else
    echo "Git user name (email is set per-repo with: git config user.email '...')"
    default_name="$(getent passwd "$(id -un)" | cut -d: -f5 | cut -d, -f1 2>/dev/null || id -un)"
    read -r -p "  Name [$default_name]: " git_name
    git_name="${git_name:-$default_name}"
    mkdir -p "$(dirname "$GIT_CONF")"
    cat > "$GIT_CONF" <<EOF
# Git user identity — created by bootstrap.sh, not tracked in repo
# Set email per repo: git config user.email "you@example.com"
[user]
    name = $git_name
EOF
    echo "  → Written to $GIT_CONF"
fi

echo ""

# ── Corporate proxy ───────────────────────────────────────────────────────────
# Skip if proxy is already set in the environment.
if [[ -z "${http_proxy:-}${HTTP_PROXY:-}" ]]; then
    read -r -p "Corporate proxy URL (leave blank if none): " proxy_url
    if [[ -n "$proxy_url" ]]; then
        export http_proxy="$proxy_url"
        export https_proxy="$proxy_url"
        echo "  → Configuring nix daemon proxy (requires sudo)..."
        sudo mkdir -p /etc/systemd/system/nix-daemon.service.d
        sudo tee /etc/systemd/system/nix-daemon.service.d/proxy.conf > /dev/null <<EOF
[Service]
Environment="http_proxy=$proxy_url"
Environment="https_proxy=$proxy_url"
Environment="no_proxy=localhost,127.0.0.1"
EOF
        sudo systemctl daemon-reload && sudo systemctl restart nix-daemon
        echo "  → Nix daemon proxy configured"
    fi
else
    echo "✓ Proxy already set in environment (${http_proxy:-$HTTP_PROXY})"
fi

echo ""
echo "Running home-manager switch..."
echo ""

# ── Apply home-manager config ─────────────────────────────────────────────────
cd "$DOTFILES_DIR"
if command -v home-manager &> /dev/null; then
    home-manager switch --flake .#default --impure
else
    # First-time bootstrap: home-manager not yet in PATH
    nix run github:nix-community/home-manager -- switch --flake .#default --impure
fi

echo ""
echo "╔══════════════════════════════════════╗"
echo "║              All done!               ║"
echo "╚══════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo "  1. Set terminal font to 'FiraCode Nerd Font'"
echo "  2. Set nushell as default: chsh -s \$(which nu)"
echo "  3. Per-repo git email:    git config user.email 'you@example.com'"
echo "  4. Machine-specific env:  \$HOME/.config/nushell/local.nu"
echo ""
