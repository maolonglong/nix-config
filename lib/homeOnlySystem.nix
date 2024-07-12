{
  inputs,
  myvars,
  genSpecialArgs,
  homeModules ? [],
  specialArgs ? (genSpecialArgs myvars),
  ...
}: let
  inherit (myvars) system;
  inherit (inputs) nixpkgs home-manager nix-index-database;
in
  home-manager.lib.homeManagerConfiguration {
    pkgs = import nixpkgs {
      inherit system;
      overlays = import ../overlays {};
      config.allowUnfree = true;
    };
    extraSpecialArgs = specialArgs;
    modules =
      [
        nix-index-database.hmModules.nix-index # command-not-found
      ]
      ++ homeModules;
  }
