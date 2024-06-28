{
  inputs,
  lib,
  myvars,
  genSpecialArgs,
  nixosModules,
  homeModules ? [],
  specialArgs ? (genSpecialArgs myvars),
  ...
}: let
  inherit (myvars) system;
  inherit (inputs) nixpkgs home-manager nix-index-database;
in
  nixpkgs.lib.nixosSystem {
    inherit system specialArgs;
    modules =
      nixosModules
      ++ [
        nix-index-database.darwinModules.nix-index # command-not-found
      ]
      ++ (
        lib.optionals ((lib.lists.length homeModules) > 0)
        [
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              verbose = true;
              backupFileExtension = "hm_bak~";
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${myvars.username}.imports = homeModules;
              extraSpecialArgs = specialArgs;
            };
          }
        ]
      );
  }
