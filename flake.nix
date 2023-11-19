{
  description = "chensl's system config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
  in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#QNR3WWC3PW
      darwinConfigurations.${vars.hostname} = nix-darwin.lib.darwinSystem {
        modules = [
          ({pkgs, ...}: {
            nixpkgs.overlays = [rust-overlay.overlays.default];
          })
          ragenix.darwinModules.default
          ./configuration.nix
          home-manager.darwinModules.home-manager
          nix-index-database.darwinModules.nix-index # command-not-found
          {
            home-manager = {
              verbose = true;
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${vars.username} = import ./home;
              extraSpecialArgs = {inherit vars;};
            };
          }
        ];
        specialArgs = {
          inherit inputs;
          inherit vars;
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem
    (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [];
      };
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = [
          pkgs.alejandra
        ];
      };
    });
}
