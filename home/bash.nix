{
  config,
  pkgs,
  lib,
  flakeDir,
  ...
}:
{
  # Keep bash configured by home-manager as a fallback shell and for
  # environments where nushell isn't the login shell yet.
  # All shell integrations (starship, zoxide, fzf, direnv) are auto-injected
  # by their respective programs.*.enableBashIntegration = true options.
  # ~/.inputrc — readline config, read before any bash/fzf binding setup.
  # Ensures emacs keymap is active so fzf's Ctrl-R bind never hits
  # "cannot find keymap for command" in tmux panes.
  home.file.".inputrc".text = ''
    set editing-mode emacs
    set keymap emacs
    set completion-ignore-case on
    set show-all-if-ambiguous on
    set mark-symlinked-directories on
  '';

  programs.bash = {
    enable = true;

    historyControl = [
      "erasedups"
      "ignorespace"
    ];
    historySize = 10000;
    historyFileSize = 10000;
    shellOptions = [ "histappend" ];

    sessionVariables = {
      VISUAL = "nvim";
      EDITOR = "nvim";
      PAGER = "less";
      LESS = "-RF";
    };

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      ll = "eza -1 --icons --long --git-ignore";
      lla = "eza -1 --icons --long --all";
      la = "eza --all";
      l = "eza --icons";
      tree = "eza --icons --tree";
      cat = "bat";
      vim = "nvim";
      sudo = "sudo -E";
      envgrep = "env | grep";
      termreset = "tput cnorm";
    };

    # Extra init loaded after the generated rc content.
    # Keeps bash usable as a fallback without duplicating nushell aliases.
    initExtra = ''
      # cargo / rust toolchain
      [[ -d "$HOME/.cargo/bin" ]] && export PATH="$PATH:$HOME/.cargo/bin"

      # Restore terminal state before each prompt.
      # stty sane: guards against tools like `adb logcat` that disable echo.
      PROMPT_COMMAND="''${PROMPT_COMMAND:+$PROMPT_COMMAND; }stty sane"

      # Re-register fzf's Ctrl-R binding before each prompt.
      # zoxide's fzf-based TAB completion corrupts readline's bind -x keymap
      # entries (fzf manipulates terminal state inside a readline callback).
      # __fzf_history__ still exists as a function — only the bind -x entry is
      # wiped. Re-running the single bind call restores it, same as re-sourcing
      # .bashrc. This is the minimal fix with no loss of functionality.
      __fzf_rebind() {
        bind -m emacs-standard -x '"\C-r": __fzf_history__' 2>/dev/null || true
      }
      PROMPT_COMMAND="''${PROMPT_COMMAND:+$PROMPT_COMMAND; }__fzf_rebind"

      # Proxy passthrough (populated by bootstrap.sh if needed; noop otherwise)
      # export http_proxy=...  → set in ~/.config/nushell/local.nu or here

      # Source machine-local overrides (not tracked in repo)
      [[ -f "$HOME/.config/bash/local.sh" ]] && source "$HOME/.config/bash/local.sh"
    '';

    # Switch to nushell for interactive login shells without needing chsh or sudo.
    # NU_VERSION is set by nushell itself, so this guard prevents re-exec loops.
    # profileExtra = ''
    #   if [[ -z "$NU_VERSION" ]] && command -v nu &>/dev/null; then
    #     exec nu --login
    #   fi
    # '';
  };
}
