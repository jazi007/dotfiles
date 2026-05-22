{
  config,
  pkgs,
  lib,
  flakeDir,
  ...
}:
{
  # programs.tmux.enable = true would install tmux but also generate
  # ~/.config/tmux/tmux.conf (XDG path, loaded first by tmux 3.x) with
  # home-manager defaults (mouse=off). We can't override that path with a
  # symlink alongside enable=true — home-manager throws a collision error.
  # Solution: install tmux manually + symlink both config paths ourselves.
  home.packages = [ pkgs.tmux ];

  # ~/.tmux.conf — fallback for tmux < 3.x
  home.file.".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/tmux.conf";
  # ~/.config/tmux/tmux.conf — XDG path, loaded first by tmux 3.x
  home.file.".config/tmux/tmux.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${flakeDir}/tmux.conf";

  # Fetch the iceberg theme that tmux.conf sources at runtime.
  # This replaces the wget call in set_env.sh.
  home.file.".tmux/iceberg.tmux.conf" = {
    source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/gkeep/iceberg-dark/master/.tmux/iceberg.tmux.conf";
      sha256 = "sha256-upCnm7tL0K7rg+45URIG4jmIcEECuKLxHcApGaTmQp4=";
    };
  };
}
