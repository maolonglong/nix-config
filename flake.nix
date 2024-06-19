{
  description = "My nix config for macOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    # TODO: remove nur
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
      url = "github:ryan4yin/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-darwin,
    maolonglong-nur,
    nix-darwin,
    home-manager,
    agenix,
    flake-utils,
    nix-index-database,
    ...
  } @ inputs: let
    mylib = import ./lib {inherit (nixpkgs) lib;};
    myvars = {
      system = "aarch64-darwin";
      username = "chensl";
      homeDir = "/Users/chensl";
      hostname = "chensl-mba"; # scutil --get LocalHostName
    };

    specialArgs = {
      inherit inputs myvars mylib;
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit (myvars) system;
        config.allowUnfree = true;
      };
    };

    home = {
      home-manager = {
        verbose = true;
        backupFileExtension = "hm_bak~";
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${myvars.username} = import ./home;
        sharedModules = [
          # agenix.homeManagerModules.default
          maolonglong-nur.homeManagerModules.default
        ];
        extraSpecialArgs = specialArgs;
      };
    };
  in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#chensl-mba
      darwinConfigurations.${myvars.hostname} = nix-darwin.lib.darwinSystem {
        modules = [
          {nixpkgs.pkgs = import nixpkgs-darwin {inherit (myvars) system;};}
          home-manager.darwinModules.home-manager
          nix-index-database.darwinModules.nix-index # command-not-found
          ./secrets/darwin.nix
          ./configuration.nix
          home
        ];
        inherit specialArgs;
      };
    }
    // flake-utils.lib.eachDefaultSystem
    (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          alejandra
          nil
        ];
      };

      formatter = pkgs.alejandra;
    });
}
