{
  config,
  pkgs,
  lib,
  flakeDir,
  ...
}:
{
  programs.direnv = {
    enable = true;

    # nix-direnv: faster, cached nix-shell/flake devshells.
    # Adds `use nix` and `use flake` to the direnv stdlib.
    nix-direnv.enable = true;

    # Shell hooks — home-manager injects these automatically
    enableBashIntegration = true;
    enableNushellIntegration = true;
  };
}
