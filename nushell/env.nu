# env.nu — environment variables loaded before config.nu
# Managed by dotfiles. Do not edit directly; edit nushell/env.nu in the repo.

# ── PATH ─────────────────────────────────────────────────────────────────────
# Keep inherited PATH, move user-local bins to the end so nix profile wins.
$env.PATH = (
  $env.PATH
  | split row (char esep)
  | where { |p| $p != $"($env.HOME)/.cargo/bin" and $p != $"($env.HOME)/.local/bin" }
  | append $"($env.HOME)/.local/bin"
  | append $"($env.HOME)/.cargo/bin"
  | uniq
)

# ── Editor ───────────────────────────────────────────────────────────────────
$env.VISUAL = "nvim"
$env.EDITOR = "nvim"

# ── Pager ────────────────────────────────────────────────────────────────────
$env.PAGER = "less"
$env.LESS  = "-RF"

# ── Proxy ────────────────────────────────────────────────────────────────────
# Uncomment and fill in if behind a proxy, or set from a local ~/.config/nushell/local.nu
# $env.http_proxy  = "http://proxy.example.com:3128"
# $env.https_proxy = "http://proxy.example.com:3128"
# $env.no_proxy    = "localhost,127.0.0.1"

# ── Starship ─────────────────────────────────────────────────────────────────
# STARSHIP_CONFIG is set by home/starship.nix via xdg.configFile symlink.
# starship init is injected by home-manager's programs.starship.enableNushellIntegration.

# ── Zoxide ───────────────────────────────────────────────────────────────────
# Initialised in config.nu via `source ~/.zoxide.nu` after zoxide generates it.
# home-manager runs: zoxide init nushell > ~/.zoxide.nu
