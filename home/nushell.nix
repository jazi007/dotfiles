{
  config,
  pkgs,
  lib,
  flakeDir,
  ...
}:
{
  programs.nushell = {
    enable = true;

    # Live symlinks to repo files — edit in place, no rebuild needed.
    configFile.source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/nushell/config.nu";
    envFile.source = config.lib.file.mkOutOfStoreSymlink "${flakeDir}/nushell/env.nu";
  };

  # aliases.nu is sourced from config.nu; symlink it alongside the main files.
  xdg.configFile."nushell/aliases.nu".source =
    config.lib.file.mkOutOfStoreSymlink "${flakeDir}/nushell/aliases.nu";

  # Nord color theme for nushell — sourced from config.nu via $nu.data-dir/vendor.
  # nu_scripts ships many themes; swap "nord" for gruvbox, catppuccin, etc.
  xdg.configFile."nushell/themes/nord.nu".source =
    let
      nu_scripts = pkgs.fetchFromGitHub {
        owner = "nushell";
        repo = "nu_scripts";
        rev = "main";
        sha256 = "sha256-t8OCSDI7MqA9Q9Tv4mjd/yRac2SZvhX2x8rfcbIUT9o=";
      };
    in
    "${nu_scripts}/themes/nu-themes/nord.nu";

  # Generate zoxide init file for nushell.
  home.activation.zoxideNushell = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.zoxide}/bin/zoxide init nushell > "$HOME/.zoxide.nu"
  '';

  # Nushell's `source` is parsed at startup — the file must exist even when empty.
  # This creates local.nu on first bootstrap; the user can add machine-specific
  # overrides (proxy, aliases, etc.) there without touching the repo.
  home.activation.nushellLocalConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    local_nu="$HOME/.config/nushell/local.nu"
    if [ ! -f "$local_nu" ]; then
      mkdir -p "$(dirname "$local_nu")"
      touch "$local_nu"
    fi
  '';
}
