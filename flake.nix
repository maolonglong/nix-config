{
  description = "My nix-darwin configuration";

  inputs = {
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
      inputs.darwin.follows = "nix-darwin";
      inputs.home-manager.follows = "home-manager";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    mysecrets = {
      url = "git+ssh://git@github.com/maolonglong/nix-secrets.git?shallow=1";
      flake = false;
    };

    mynur = {
      url = "github:maolonglong/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    catppuccin = {
      url = "github:catppuccin/nix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs-darwin,
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
      specialArgs = {
        inherit inputs myvars;
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

    evalDarwinConfiguration = name: username: hostname: let
      config = self.darwinConfigurations.${name}.config;
      home = config.home-manager.users.${username};
      check = nixpkgs-darwin.lib.assertMsg;
    in
      assert check (config.system.primaryUser == username) "${name}: unexpected primary user";
      assert check (config.users.users.${username}.home == "/Users/${username}") "${name}: unexpected system home";
      assert check (home.home.username == username && home.home.homeDirectory == "/Users/${username}") "${name}: unexpected Home Manager identity";
      assert check (config.networking.hostName == hostname) "${name}: unexpected hostname";
      assert check (name != "work-mbp" || (!home.programs.git.enable && !home.programs.ssh.enable)) "work-mbp: Home Manager must not manage Git or SSH";
        pkgs.writeText "eval-${name}" (
          builtins.unsafeDiscardStringContext
          config.system.build.toplevel.drvPath
        );
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
      personal-mba-eval = evalDarwinConfiguration "personal-mba" "chensl" "chensl-mba";
      work-mbp-eval = evalDarwinConfiguration "work-mbp" "bytedance" "QNR3WWC3PW";
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
