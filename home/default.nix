{
  config,
  pkgs,
  lib,
  flakeDir,
  ...
}:
{
  imports = [
    ./tools.nix
    ./git.nix
    ./starship.nix
    ./tmux.nix
    ./bash.nix
    ./nushell.nix
    ./direnv.nix
  ];

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # Bump this only when home-manager itself introduces breaking changes.
  # See: https://nix-community.github.io/home-manager/release-notes.html
  home.stateVersion = "24.11";
}
