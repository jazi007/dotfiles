{ config, pkgs, lib, flakeDir, ... }:
{
  programs.nushell = {
    enable = true;

    # Live symlinks to repo files — edit in place, no rebuild needed.
    configFile.source =
      config.lib.file.mkOutOfStoreSymlink "${flakeDir}/nushell/config.nu";
    envFile.source =
      config.lib.file.mkOutOfStoreSymlink "${flakeDir}/nushell/env.nu";
  };

  # aliases.nu is sourced from config.nu; symlink it alongside the main files.
  xdg.configFile."nushell/aliases.nu".source =
    config.lib.file.mkOutOfStoreSymlink "${flakeDir}/nushell/aliases.nu";

  # Generate zoxide init file for nushell.
  # config.nu sources this if it exists, so the activation is non-blocking.
  home.activation.zoxideNushell = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.zoxide}/bin/zoxide init nushell > "$HOME/.zoxide.nu"
  '';
}
