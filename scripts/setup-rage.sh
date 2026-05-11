#!/usr/bin/env bash
# setup-rage.sh — one-time rage/age secret encryption setup
# Generates an SSH key (if needed) and encrypts your tokens with rage.
# After this runs, use .envrc in each project to inject secrets.
set -euo pipefail

SECRETS_DIR="$HOME/.secrets"
SSH_KEY="$HOME/.ssh/id_ed25519"
SSH_PUB="$HOME/.ssh/id_ed25519.pub"

# ── colours ────────────────────────────────────────────────────────────────────
bold=$(tput bold 2>/dev/null || true)
reset=$(tput sgr0 2>/dev/null || true)
green=$(tput setaf 2 2>/dev/null || true)
cyan=$(tput setaf 6 2>/dev/null || true)

info()    { echo "${cyan}${bold}==> $*${reset}"; }
success() { echo "${green}${bold}    ✓ $*${reset}"; }

# ── 1. SSH key ─────────────────────────────────────────────────────────────────
info "Checking SSH key..."
if [[ -f "$SSH_KEY" ]]; then
    success "SSH key already exists at $SSH_KEY"
else
    read -rp "    Enter your email for the SSH key: " email
    ssh-keygen -t ed25519 -C "$email" -f "$SSH_KEY"
    success "SSH key generated"
fi

# ── 2. secrets directory ───────────────────────────────────────────────────────
info "Creating $SECRETS_DIR ..."
mkdir -p "$SECRETS_DIR"
chmod 700 "$SECRETS_DIR"
success "Done"

# ── 3. encrypt tokens ──────────────────────────────────────────────────────────
encrypt_secret() {
    local name="$1"
    local out="$SECRETS_DIR/${name}.age"
    if [[ -f "$out" ]]; then
        read -rp "    $out already exists — overwrite? [y/N] " yn
        [[ "$yn" =~ ^[Yy]$ ]] || return 0
    fi
    read -rsp "    Enter value for $name (input hidden): " value
    echo
    echo "$value" | rage -r "$(cat "$SSH_PUB")" -o "$out"
    chmod 600 "$out"
    success "Encrypted → $out"
}

info "Encrypting secrets (leave blank to skip)..."

for token in github-token gitlab-token cargo-token artifactory-token; do
    read -rp "    Encrypt $token? [y/N] " yn
    [[ "$yn" =~ ^[Yy]$ ]] && encrypt_secret "$token" || true
done

# ── 4. print .envrc snippet ────────────────────────────────────────────────────
echo
info "Add this to your project .envrc as needed:"
cat <<'ENVRC'

    # ── secrets (rage) ───────────────────────────────────────────────────────
    RAGE_KEY=~/.ssh/id_ed25519

    # Uncomment what you need:
    # export GITHUB_TOKEN=$(rage -d -i $RAGE_KEY ~/.secrets/github-token.age)
    # export GITLAB_TOKEN=$(rage -d -i $RAGE_KEY ~/.secrets/gitlab-token.age)
    # export CARGO_REGISTRY_TOKEN=$(rage -d -i $RAGE_KEY ~/.secrets/cargo-token.age)
    # export ARTIFACTORY_TOKEN=$(rage -d -i $RAGE_KEY ~/.secrets/artifactory-token.age)

ENVRC

info "Git HTTPS credential helper (add to ~/.gitconfig or per-repo .git/config):"
cat <<'GITCONF'

    [credential "https://github.com"]
        username = your-username
        helper = "!f() { echo password=$(rage -d -i ~/.ssh/id_ed25519 ~/.secrets/github-token.age); }; f"

    [credential "https://gitlab.com"]
        username = your-username
        helper = "!f() { echo password=$(rage -d -i ~/.ssh/id_ed25519 ~/.secrets/gitlab-token.age); }; f"

GITCONF

success "rage setup complete!"
