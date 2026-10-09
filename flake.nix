{
  description = "My nix-darwin configuration";

  inputs = {
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
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

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
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
    git-hooks,
    catppuccin,
    ...
  }: let
    system = "aarch64-darwin";
    pkgs = nixpkgs-darwin.legacyPackages.${system};

    # A host is `hosts/<name>/`: `vars.nix` (identity), `default.nix` (system
    # overrides) and `home.nix` (Home Manager overrides).
    mkDarwin = name: let
      myvars = import ./hosts/${name}/vars.nix;
      specialArgs = {inherit inputs myvars;};
    in
      nix-darwin.lib.darwinSystem {
        inherit specialArgs;
        modules = [
          {
            nixpkgs = {
              hostPlatform = system;
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
              users.${myvars.username}.imports = [
                catppuccin.homeModules.catppuccin
                {catppuccin.flavor = "mocha";}
                ./home
                ./hosts/${name}/home.nix
              ];
            };
          }

          ./hosts/${name}
        ];
      };

    preCommitCheck = git-hooks.lib.${system}.run {
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

    # Facts each host must keep. They are spelled out here instead of derived
    # from hosts/, so drift in hosts/ or mkDarwin fails `nix flake check`. This
    # attrset also names the hosts, so none can exist without expectations.
    hostExpectations = {
      personal-mba = {
        hostname = "chensl-mba";
        managesGitAndSsh = true;
      };
      work-mbp = {
        hostname = "CRWQCPJC7G";
        managesGitAndSsh = false;
      };
    };

    evalDarwinConfiguration = name: {
      hostname,
      managesGitAndSsh,
    }: let
      config = self.darwinConfigurations.${name}.config;
      user = config.system.primaryUser;
      home = config.home-manager.users.${user};
      check = nixpkgs-darwin.lib.assertMsg;
    in
      assert check (home.home.username == user) "${name}: Home Manager user differs from primary user";
      assert check (home.home.homeDirectory == config.users.users.${user}.home) "${name}: Home Manager and system home directories differ";
      assert check (config.networking.hostName == hostname) "${name}: unexpected hostname";
      assert check (home.programs.git.enable == managesGitAndSsh) "${name}: unexpected Home Manager Git management";
      assert check (home.programs.ssh.enable == managesGitAndSsh) "${name}: unexpected Home Manager SSH management";
        pkgs.writeText "eval-${name}" (
          builtins.unsafeDiscardStringContext
          config.system.build.toplevel.drvPath
        );
  in {
    darwinConfigurations = nixpkgs-darwin.lib.genAttrs (builtins.attrNames hostExpectations) mkDarwin;

    checks.${system} =
      {pre-commit-check = preCommitCheck;}
      // nixpkgs-darwin.lib.mapAttrs' (name: expect: {
        name = "${name}-eval";
        value = evalDarwinConfiguration name expect;
      })
      hostExpectations;

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
