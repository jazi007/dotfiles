{
  config,
  pkgs,
  lib,
  flakeDir,
  ...
}:
{
  programs.tmux = {
    enable = true;

    # Live symlink: the repo's tmux.conf is the source of truth.
    # home-manager's programs.tmux generates its own config file, so we
    # bypass that and symlink directly instead.
  };

  # Symlink tmux.conf directly — bypasses home-manager's generated config so
  # the existing tmux.conf is used unchanged.
  home.file.".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/tmux.conf";

  # Fetch the iceberg theme that tmux.conf sources at runtime.
  # This replaces the wget call in set_env.sh.
  home.file.".tmux/iceberg.tmux.conf" = {
    source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/gkeep/iceberg-dark/master/.tmux/iceberg.tmux.conf";
      sha256 = "sha256-upCnm7tL0K7rg+45URIG4jmIcEECuKLxHcApGaTmQp4=";
    };
  };
}
