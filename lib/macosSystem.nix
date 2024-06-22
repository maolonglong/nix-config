{
  lib,
  inputs,
  darwin-modules,
  home-modules ? [],
  myvars,
  system,
  genSpecialArgs,
  specialArgs ? (genSpecialArgs myvars),
  ...
}: let
  inherit (inputs) nixpkgs-darwin home-manager nix-darwin nix-index-database;
in
  nix-darwin.lib.darwinSystem {
    inherit system specialArgs;
    modules =
      darwin-modules
      ++ [
        {nixpkgs.pkgs = import nixpkgs-darwin {inherit system;};}
        nix-index-database.darwinModules.nix-index # command-not-found
      ]
      ++ (
        lib.optionals ((lib.lists.length home-modules) > 0)
        [
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              verbose = true;
              backupFileExtension = "hm_bak~";
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${myvars.username}.imports = home-modules;
              extraSpecialArgs = specialArgs;
            };
          }
        ]
      );
  }
