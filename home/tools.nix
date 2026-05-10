{
  config,
  pkgs,
  lib,
  flakeDir,
  ...
}:
{
  home.packages = with pkgs; [
    # ── Editor ─────────────────────────────────────────────────────────────────
    neovim # managed by nix — always a recent version

    # ── Filesystem ─────────────────────────────────────────────────────────────
    eza # modern ls (replaces ls aliases)
    bat # syntax-highlighted cat
    fd # fast find (used by telescope too)
    ripgrep # fast grep (used by telescope live_grep)
    tree # fallback tree view

    # ── Navigation ─────────────────────────────────────────────────────────────
    zoxide # smart cd with frecency ranking

    # ── Fuzzy ──────────────────────────────────────────────────────────────────
    fzf # fuzzy finder (shell integration below)

    # ── Git ────────────────────────────────────────────────────────────────────
    delta # syntax-highlighted git diff pager
    lazygit # TUI git client (used by snacks.lazygit in nvim)

    # ── Fonts (Nerd Fonts — required for nvim icons, starship glyphs) ──────────
    nerd-fonts.fira-code # FiraCode with Nerd Font glyphs
    nerd-fonts.symbols-only # Symbols-only fallback for any terminal font

    # ── Build / misc ───────────────────────────────────────────────────────────
    gnumake
    curl
    wget
    unzip
    jq # JSON processor
    yq-go # YAML processor

    # ── Shell completions ───────────────────────────────────────────────────────
    carapace # universal external completer (cargo, git, docker, kubectl, ...)
  ];

  # ── fzf shell integration ────────────────────────────────────────────────────
  # Provides: CTRL-R history, CTRL-T file, ALT-C cd — in any shell
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    # Nushell integration is handled in nushell/config.nu via `source`
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--border"
      "--reverse"
    ];
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidgetOptions = [ "--preview 'bat --color=always {}'" ];
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
  };

  # ── zoxide (smart cd) ────────────────────────────────────────────────────────
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    # Nushell integration is handled via `zoxide init nushell` in nushell/env.nu
  };

  # ── bat ──────────────────────────────────────────────────────────────────────
  programs.bat = {
    enable = true;
    config = {
      theme = "Nord";
      pager = "less -FR";
      style = "numbers,changes,header";
    };
  };

  # ── eza ──────────────────────────────────────────────────────────────────────
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
    extraOptions = [ "--group-directories-first" ];
  };
}
