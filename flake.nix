{
  description = "My nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";

    nix-darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "nix-darwin";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
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

    catppuccin.url = "github:catppuccin/nix/release-25.11";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-darwin,
    nixpkgs-unstable,
    nix-darwin,
    home-manager,
    nix-index-database,
    pre-commit-hooks,
    catppuccin,
    ...
  }: let
    system = "aarch64-darwin";
    pkgs = nixpkgs-darwin.legacyPackages.${system};

    mkDarwin = {
      username,
      userfullname,
      useremail,
      hostModules,
      homeModules,
    }: let
      myvars = {
        inherit system username userfullname useremail;
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      specialArgs = {
        inherit inputs myvars pkgs-unstable;
      };
    in
      nix-darwin.lib.darwinSystem {
        inherit system specialArgs;
        modules =
          [
            {
              nixpkgs.pkgs = import nixpkgs-darwin {
                inherit system;
                config.allowUnfree = true;
              };
            }

            ./modules/darwin
            nix-index-database.darwinModules.nix-index

            home-manager.darwinModules.home-manager
            {
              home-manager = {
                verbose = true;
                backupFileExtension = "hm_bak~";
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
                users.${username}.imports =
                  [
                    catppuccin.homeModules.catppuccin
                    {
                      catppuccin.flavor = "mocha";
                    }
                    ./home
                  ]
                  ++ homeModules;
              };
            }
          ]
          ++ hostModules;
      };

    preCommitCheck = pre-commit-hooks.lib.${system}.run {
      src = ./.;
      hooks = {
        alejandra.enable = true;
        typos = {
          enable = true;
          settings = {
            write = true;
            configPath = "./.typos.toml";
          };
        };
        taplo.enable = true;
        gitleaks = {
          enable = true;
          name = "Detect hardcoded secrets";
          entry = "${pkgs.gitleaks}/bin/gitleaks git --pre-commit --redact --staged --verbose";
          pass_filenames = false;
        };
      };
    };
  in {
    darwinConfigurations = {
      personal-mba = mkDarwin {
        username = "chensl";
        userfullname = "Shaolong Chen";
        useremail = "shaolong.chen@outlook.it";
        hostModules = [./hosts/personal-mba];
        homeModules = [./hosts/personal-mba/home.nix];
      };

      work-mbp = mkDarwin {
        username = "bytedance";
        userfullname = "Shaolong Chen";
        useremail = "chenshaolong.1016@bytedance.com";
        hostModules = [./hosts/work-mbp];
        homeModules = [./hosts/work-mbp/home.nix];
      };
    };

    checks.${system} = {
      pre-commit-check = preCommitCheck;
    };

    formatter.${system} = pkgs.alejandra;

    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        alejandra
        nil
        taplo
        typos
      ];
      shellHook = preCommitCheck.shellHook;
    };
  };
}
