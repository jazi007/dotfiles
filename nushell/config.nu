# config.nu — main Nushell config
# Managed by dotfiles. Do not edit directly; edit nushell/config.nu in the repo.

# ── Aliases ───────────────────────────────────────────────────────────────────
source ~/.config/nushell/aliases.nu

# ── Zoxide (smart cd) ─────────────────────────────────────────────────────────
# home-manager generates this file via: zoxide init nushell | save -f ~/.zoxide.nu
if ($"($env.HOME)/.zoxide.nu" | path exists) {
  source ~/.zoxide.nu
}

# ── History ───────────────────────────────────────────────────────────────────
$env.config = {
  history: {
    max_size:     100_000
    sync_on_enter: true
    file_format:  "sqlite"   # richer history with timestamps and durations
  }

  # ── Completions ─────────────────────────────────────────────────────────────
  completions: {
    case_sensitive: false
    quick:          true
    partial:        true
    algorithm:      "fuzzy"
    external: {
      enable:      true
      max_results: 100
    }
  }

  # ── Editor ──────────────────────────────────────────────────────────────────
  edit_mode: "vi"   # vi keybindings — matches nvim workflow

  # ── Display ─────────────────────────────────────────────────────────────────
  show_banner: false

  table: {
    mode:             "rounded"
    index_mode:       "always"
    trim: {
      methodology:    "wrapping"
      wrapping_try_keep_words: true
    }
  }

  # ── Keybindings ─────────────────────────────────────────────────────────────
  keybindings: [
    # CTRL-R: fzf history search
    {
      name:     fzf_history
      modifier: control
      keycode:  char_r
      mode:     [emacs, vi_normal, vi_insert]
      event: {
        send: ExecuteHostCommand
        cmd:  "commandline edit (history | each { |it| $it.command } | reverse | uniq | str join (char nl) | fzf --height 40% --reverse --border | str trim)"
      }
    }
    # CTRL-T: fzf file picker
    {
      name:     fzf_file
      modifier: control
      keycode:  char_t
      mode:     [emacs, vi_normal, vi_insert]
      event: {
        send: ExecuteHostCommand
        cmd:  "commandline edit (fd --type f --hidden --exclude .git | fzf --height 40% --preview 'bat --color=always {}' --border | str trim)"
      }
    }
  ]
}

# ── Local overrides (machine-specific, not in repo) ───────────────────────────
# ~/.config/nushell/local.nu is created empty by home-manager on first run.
# Add proxy settings, work-specific aliases, etc. there.
source ~/.config/nushell/local.nu
