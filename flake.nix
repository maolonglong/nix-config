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

    # add git hooks to format nix code before commit
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
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

    mkDarwin = myvars: modules: let
      args =
        {
          inherit (myvars) system;
          inherit inputs lib mylib myvars genSpecialArgs;
        }
        // modules;
    in
      mylib.macosSystem args;
  in
    {
      # macOS Hosts
      darwinConfigurations = {
        chensl-mba = let
          myvars = {
            system = "aarch64-darwin";
            username = "chensl";
            homeDir = "/Users/chensl";
            hostname = "chensl-mba";
          };
          modules = {
            darwin-modules = map mylib.relativeToRoot [
              "secrets/darwin.nix"
              "configuration.nix"
              "hosts/darwin-${myvars.hostname}"
            ];
            home-modules = map mylib.relativeToRoot [
              "home"
            ];
          };
        in
          mkDarwin myvars modules;
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            alejandra
            nil
            typos
          ];
          shellHook = self.checks.${system}.pre-commit-check.shellHook;
        };

        # Format the nix code in this flake
        formatter =
          # alejandra is a nix formatter with a beautiful output
          pkgs.alejandra;

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
            };
          };
        };
      }
    );
}
