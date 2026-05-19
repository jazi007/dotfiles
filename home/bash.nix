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

      # Restore terminal state before each prompt (guards against tools like
      # `adb logcat` that disable echo when interrupted with Ctrl-C).
      PROMPT_COMMAND="''${PROMPT_COMMAND:+$PROMPT_COMMAND; }stty sane"

      # Proxy passthrough (populated by bootstrap.sh if needed; noop otherwise)
      # export http_proxy=...  → set in ~/.config/nushell/local.nu or here

      # Source machine-local overrides (not tracked in repo)
      [[ -f "$HOME/.config/bash/local.sh" ]] && source "$HOME/.config/bash/local.sh"
    '';

    # Switch to nushell for interactive login shells without needing chsh or sudo.
    # NU_VERSION is set by nushell itself, so this guard prevents re-exec loops.
    profileExtra = ''
      if [[ -z "$NU_VERSION" ]] && command -v nu &>/dev/null; then
        exec nu --login
      fi
    '';
  };
}
