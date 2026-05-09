{
  description = "Personal dotfiles — home-manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # ---------------------------------------------------------------------------
      # No hardcoded usernames. These are read from the environment at eval time.
      # Always run with: home-manager switch --flake .#default --impure
      # ---------------------------------------------------------------------------
      username    = builtins.getEnv "USER";
      homeDir     = builtins.getEnv "HOME";
      # Absolute path of this repo on disk — used for live symlinks (edit-in-place)
      flakeDir    = toString ./.;
    in
    {
      homeConfigurations.default = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Pass flakeDir (and any future shared args) to all modules
        extraSpecialArgs = { inherit flakeDir; };

        modules = [
          # Identity — sourced entirely from env, never hardcoded
          {
            home.username      = username;
            home.homeDirectory = homeDir;
          }
          ./home/default.nix
        ];
      };
    };
}
