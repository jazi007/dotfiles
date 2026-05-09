{
  config,
  pkgs,
  lib,
  flakeDir,
  ...
}:
{
  programs.starship = {
    enable = true;
    # Live symlink to the repo's starship.toml — edit the file and changes
    # take effect immediately without re-running home-manager switch.
    enableBashIntegration = true;
    enableNushellIntegration = true;
  };

  # Point STARSHIP_CONFIG at the repo file directly so a single toml is the
  # source of truth across all shells.
  xdg.configFile."starship.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${flakeDir}/starship.toml";
}
