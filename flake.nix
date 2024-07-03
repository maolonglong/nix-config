{
  description = "My nix config for macOS & NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

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

    # add git hooks to format nix code before commit
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mysecrets = {
      url = "git+ssh://git@github.com/maolonglong/nix-secrets.git?shallow=1";
      flake = false;
    };

    mynur = {
      url = "github:maolonglong/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    pre-commit-hooks,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    mylib = import ./lib {inherit lib;};

    genSpecialArgs = myvars: {
      inherit inputs mylib myvars;

      # use unstable branch for some packages to get the latest updates
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit (myvars) system; # refer the `system` parameter form outer scope recursively
        # To use chrome, we need to allow the installation of non-free software
        config.allowUnfree = true;
      };
      # pkgs-stable = import inputs.nixpkgs-stable {
      #   inherit system;
      #   # To use chrome, we need to allow the installation of non-free software
      #   config.allowUnfree = true;
      # };
    };

    # common arguments pass to darwin & nixos hosts
    commonArgs = {inherit inputs lib mylib genSpecialArgs;};

    nixosHosts = {
      nixos = rec {
        myvars = {
          system = "aarch64-linux";
          username = "chensl";
          homeDirectory = "/home/chensl";
          hostname = "nixos";
        };
        nixosModules = [
          ./modules/nixos
          # ./secrets/nixos.nix
          (./. + "/hosts/orbstack-${myvars.hostname}")
        ];
        homeModules = [
          ./home/base/core
          # ./home/base/gui
          ./home/base/tui
          ./home/base/home.nix
          # (./. + "/hosts/darwin-${myvars.hostname}/home.nix")
        ];
      };
    };

    darwinHosts = {
      chensl-mba = rec {
        myvars = {
          system = "aarch64-darwin";
          username = "chensl";
          homeDirectory = "/Users/chensl";
          hostname = "chensl-mba";
        };
        darwinModules = [
          ./modules/darwin
          ./secrets/darwin.nix
          (./. + "/hosts/darwin-${myvars.hostname}")
        ];
        homeModules = [
          ./home/darwin
          (./. + "/hosts/darwin-${myvars.hostname}/home.nix")
        ];
      };
    };
  in
    {
      nixosConfigurations =
        builtins.mapAttrs (
          _: value:
            mylib.nixosSystem (commonArgs // value)
        )
        nixosHosts;

      darwinConfigurations =
        builtins.mapAttrs (
          _: value:
            mylib.macosSystem (commonArgs // value)
        )
        darwinHosts;
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            alejandra
            nil
            taplo
            typos
          ];
          shellHook = self.checks.${system}.pre-commit-check.shellHook;
        };

        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = mylib.relativeToRoot ".";
            hooks = {
              alejandra.enable = true; # formatter
              # Source code spell checker
              typos = {
                enable = true;
                settings = {
                  write = true; # Automatically fix typos
                  configPath = "./.typos.toml"; # relative to the flake root
                };
              };
              taplo.enable = true;
            };
          };
        };

        # Format the nix code in this flake
        formatter =
          # alejandra is a nix formatter with a beautiful output
          pkgs.alejandra;
      }
    );
}
