{
  description = "chensl's system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    nur.url = "github:nix-community/NUR";
    maolonglong-nur.url = "github:maolonglong/nur-packages";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-darwin,
    nur,
    maolonglong-nur,
    nix-darwin,
    home-manager,
    agenix,
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
      {
        nixpkgs = {
          pkgs = import nixpkgs-darwin {system = vars.arch;};
          inherit overlays;
        };
      }
      home-manager.darwinModules.home-manager
    ];

    specialArgs =
      {inherit inputs vars;}
      // {
        pkgs-unstable = import inputs.nixpkgs-unstable {
          system = vars.arch; # refer the `system` parameter form outer scope recursively
          # To use chrome, we need to allow the installation of non-free software
          config.allowUnfree = true;
        };
      };

    home = {
      home-manager = {
        verbose = true;
        backupFileExtension = "hm_bak~";
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${vars.username} = import ./home;
        sharedModules = [
          agenix.homeManagerModules.default
          maolonglong-nur.homeManagerModules.default
        ];
        extraSpecialArgs = specialArgs;
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
        inherit specialArgs;
      };
    }
    // devShells;
}
