{
  inputs,
  lib,
  myvars,
  system,
  genSpecialArgs,
  nixos-modules,
  home-modules ? [],
  specialArgs ? (genSpecialArgs myvars),
  ...
}: let
  inherit (inputs) nixpkgs home-manager nix-index-database;
in
  nixpkgs.lib.nixosSystem {
    inherit system specialArgs;
    modules =
      nixos-modules
      ++ [
        nix-index-database.darwinModules.nix-index # command-not-found
      ]
      ++ (
        lib.optionals ((lib.lists.length home-modules) > 0)
        [
          home-manager.nixosModules.home-manager
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
