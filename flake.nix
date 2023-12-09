{
  description = "chensl's system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    maolonglong-nur.url = "github:maolonglong/nur-packages";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nur,
    maolonglong-nur,
    nix-darwin,
    home-manager,
    ragenix,
    flake-utils,
    nix-index-database,
    rust-overlay,
    ...
  }: let
    vars = {
      arch = "aarch64-darwin";
      username = "chensl";
      homeDir = "/Users/chensl";
      hostname = "chensl-mba"; # scutil --get LocalHostName
    };

    overlays = [
      rust-overlay.overlays.default
      (final: prev: {
        nur = import nur {
          nurpkgs = prev;
          pkgs = prev;
          repoOverrides = {
            maolonglong = import maolonglong-nur {pkgs = prev;};
          };
        };
      })
    ];

    commonModules = [
      ragenix.darwinModules.default
      {nixpkgs = {inherit overlays;};}
      home-manager.darwinModules.home-manager
    ];

    home = {
      home-manager = {
        verbose = true;
        backupFileExtension = "hm_bak~";
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${vars.username} = import ./home;
        sharedModules = [
          maolonglong-nur.homeManagerModules.default
        ];
        extraSpecialArgs = {inherit vars;};
      };
    };

    devShells =
      flake-utils.lib.eachDefaultSystem
      (system: let
        pkgs = import nixpkgs {inherit system overlays;};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            alejandra
            nil
          ];
        };
      });
  in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#chensl-mba
      darwinConfigurations.${vars.hostname} = nix-darwin.lib.darwinSystem {
        modules =
          commonModules
          ++ [
            ./configuration.nix
            home
            nix-index-database.darwinModules.nix-index # command-not-found
          ];
        specialArgs = {inherit inputs vars;};
      };
    }
    // devShells;
}
