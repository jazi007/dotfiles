#!/usr/bin/env bash
# setup-rage.sh — one-time rage/age secret encryption setup
#
# Uses a dedicated age identity key (~/.age/key.txt) — separate from SSH keys.
# Encrypted secrets live in SECRETS_HOME (default: ~/.secrets).
# Encrypted *.age files may be committed to a personal git repo safely.
#
# Cross-machine usage:
#   1. Run this script on the first machine (generates a new key).
#   2. Copy the key to each new machine: scp ~/.age/key.txt user@host:~/.age/key.txt
#   3. Set SECRETS_HOME in local.sh / local.nu if using a non-default location.
#   4. Use `get_secret` / `add_secret` shell helpers as normal.
set -euo pipefail

AGE_KEY_FILE="$HOME/.age/key.txt"
SECRETS_HOME="${SECRETS_HOME:-$HOME/.secrets}"

# ── colours ────────────────────────────────────────────────────────────────────
bold=$(tput bold 2>/dev/null || true)
reset=$(tput sgr0 2>/dev/null || true)
green=$(tput setaf 2 2>/dev/null || true)
cyan=$(tput setaf 6 2>/dev/null || true)
yellow=$(tput setaf 3 2>/dev/null || true)

info()    { echo "${cyan}${bold}==> $*${reset}"; }
success() { echo "${green}${bold}    ✓ $*${reset}"; }
warn()    { echo "${yellow}${bold}    ! $*${reset}"; }

# ── 1. age identity key ────────────────────────────────────────────────────────
info "Checking age identity key..."
mkdir -p "$(dirname "$AGE_KEY_FILE")"
chmod 700 "$(dirname "$AGE_KEY_FILE")"

if [[ -f "$AGE_KEY_FILE" ]]; then
    success "Key already exists at $AGE_KEY_FILE"
    pub=$(sed -n 's/^# public key: //p' "$AGE_KEY_FILE")
    echo "    Public key: $pub"
else
    echo "    No age key found at $AGE_KEY_FILE"
    echo "    Choose:"
    echo "      1) Generate a new key"
    echo "      2) Import an existing key from a local file path"
    read -rp "    Choice [1/2, default: 1]: " choice
    case "${choice:-1}" in
        2)
            read -rp "    Path to existing key file: " src
            [[ -f "$src" ]] || { echo "file not found: $src" >&2; exit 1; }
            cp "$src" "$AGE_KEY_FILE"
            chmod 600 "$AGE_KEY_FILE"
            success "Key imported from $src"
            ;;
        *)
            rage-keygen -o "$AGE_KEY_FILE"
            chmod 600 "$AGE_KEY_FILE"
            success "New age key generated at $AGE_KEY_FILE"
            ;;
    esac
    pub=$(sed -n 's/^# public key: //p' "$AGE_KEY_FILE")
    echo "    Public key: $pub"
    warn "Back up ~/.age/key.txt securely — it is the only way to decrypt your secrets."
fi

# ── 2. secrets directory ───────────────────────────────────────────────────────
info "Ensuring secrets directory: $SECRETS_HOME"
mkdir -p "$SECRETS_HOME"
chmod 700 "$SECRETS_HOME"
success "Done"

# ── 3. encrypt secrets interactively ──────────────────────────────────────────
encrypt_secret() {
    local name="$1"
    local out="$SECRETS_HOME/${name}.age"
    if [[ -f "$out" ]]; then
        read -rp "    $out already exists — overwrite? [y/N] " yn
        [[ "$yn" =~ ^[Yy]$ ]] || return 0
    fi
    read -rsp "    Enter value for $name (input hidden): " value
    echo
    printf '%s' "$value" | rage -r "$pub" -o "$out"
    chmod 600 "$out"
    success "Encrypted → $out"
}

echo ""
info "Encrypt secrets (skip any you don't need)..."
for token in github-token gitlab-token cargo-token artifactory-token; do
    read -rp "    Encrypt $token? [y/N] " yn
    [[ "$yn" =~ ^[Yy]$ ]] && encrypt_secret "$token" || true
done

# ── 4. print usage ─────────────────────────────────────────────────────────────
echo ""
info "Shell helpers (bash and nushell — available after home-manager switch):"
echo ""
echo "    get_secret github-token          # decrypt and print"
echo "    add_secret github-token          # prompt, encrypt, store"
echo "    list_secrets                     # list stored secret names"
echo ""
info "Override SECRETS_HOME per machine (in ~/.config/bash/local.sh or local.nu):"
cat <<'LOCAL'
    # bash
    export SECRETS_HOME="$HOME/repos/my-secrets"

    # nushell
    $env.SECRETS_HOME = $"($env.HOME)/repos/my-secrets"
LOCAL
echo ""
info "Use in .envrc (direnv):"
cat <<'ENVRC'
    export GITHUB_TOKEN=$(get_secret github-token)
    export ARTIFACTORY_TOKEN=$(get_secret artifactory-token)
    export CARGO_REGISTRY_TOKEN=$(get_secret cargo-token)
ENVRC
echo ""
info "Git HTTPS credential helper (add to ~/.gitconfig or per-repo .git/config):"
cat <<'GITCONF'
    [credential "https://github.com"]
        username = your-username
        helper = "!f() { echo password=$(get_secret github-token); }; f"

    [credential "https://gitlab.com"]
        username = your-username
        helper = "!f() { echo password=$(get_secret gitlab-token); }; f"
GITCONF
echo ""
info "Cross-machine key transfer:"
echo "    scp ~/.age/key.txt user@other-machine:~/.age/key.txt"
echo "    ssh user@other-machine 'chmod 600 ~/.age/key.txt'"
echo ""
success "rage setup complete!"
