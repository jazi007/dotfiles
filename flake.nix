{
  description = "Personal dotfiles — home-manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # ---------------------------------------------------------------------------
      # No hardcoded usernames. These are read from the environment at eval time.
      # Always run with: home-manager switch --flake .#default --impure
      # ---------------------------------------------------------------------------
      username = builtins.getEnv "USER";
      homeDir = builtins.getEnv "HOME";
      # Real on-disk path of this repo — required by mkOutOfStoreSymlink.
      # Priority: explicit $DOTFILES_DIR env var → self.outPath (nix flake source).
      # self.outPath is the nix store copy of the source, BUT when the flake is
      # loaded from a local path (path:...) with --impure it equals the real dir.
      # The clean solution: require users to set DOTFILES_DIR when outPath is a
      # store path. bootstrap.sh exports it automatically.
      flakeDir =
        let
          d = builtins.getEnv "DOTFILES_DIR";
        in
        if d != "" then d else toString self.outPath;
    in
    {
      homeConfigurations.default = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Pass flakeDir (and any future shared args) to all modules
        extraSpecialArgs = { inherit flakeDir; };

        modules = [
          # Identity — sourced entirely from env, never hardcoded
          {
            home.username = username;
            home.homeDirectory = homeDir;
          }
          ./home/default.nix
        ];
      };

      # `nix fmt` formats all .nix files in the repo using the RFC-style formatter.
      formatter.${system} = pkgs.nixfmt;
    };
}
