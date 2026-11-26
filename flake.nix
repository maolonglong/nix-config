{
  description = "My nix-darwin and Home Manager configuration";

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

    # Pin to a release tag so `just up` does not advance the secrets module to
    # unreviewed commits silently.
    agenix = {
      url = "github:ryantm/agenix/0.18.0";
      inputs = {
        nixpkgs.follows = "nixpkgs-darwin";
        darwin.follows = "nix-darwin";
        home-manager.follows = "home-manager";
      };
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
  };

  outputs = inputs @ {
    self,
    nixpkgs-darwin,
    nix-darwin,
    home-manager,
    nix-index-database,
    git-hooks,
    ...
  }: let
    inherit (nixpkgs-darwin) lib;
    darwinSystem = "aarch64-darwin";
    supportedSystems = [
      "aarch64-darwin"
      "x86_64-linux"
      "aarch64-linux"
    ];
    forAllSystems = lib.genAttrs supportedSystems;

    # A Darwin host is `hosts/<name>/`: `vars.nix` (identity), `default.nix`
    # (system overrides) and `home.nix` (Home Manager overrides).
    mkDarwin = name: let
      myvars = import ./hosts/${name}/vars.nix;
      specialArgs = {inherit inputs myvars;};
    in
      nix-darwin.lib.darwinSystem {
        inherit specialArgs;
        modules = [
          {
            nixpkgs = {
              hostPlatform = darwinSystem;
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
                ./home/base
                ./home/darwin
                ./hosts/${name}/home.nix
              ];
            };
          }

          ./hosts/${name}
        ];
      };

    # A standalone Linux Home Manager host is `hosts/<name>/`: `vars.nix` and `home.nix`.
    mkLinuxHome = name: linuxSystem: let
      myvars = import ./hosts/${name}/vars.nix;
      linuxPkgs = import nixpkgs-darwin {
        system = linuxSystem;
        config.allowUnfree = true;
      };
    in
      home-manager.lib.homeManagerConfiguration {
        pkgs = linuxPkgs;
        extraSpecialArgs = {inherit inputs myvars;};
        modules = [
          ./home/base
          ./home/linux
          ./hosts/${name}/home.nix
          {
            home = {
              inherit (myvars) username;
              homeDirectory = "/home/${myvars.username}";
            };
          }
        ];
      };

    preCommitChecks = forAllSystems (system: let
      pkgs = nixpkgs-darwin.legacyPackages.${system};
    in
      git-hooks.lib.${system}.run {
        src = ./.;
        package = pkgs.prek;
        hooks = {
          alejandra.enable = true;
          deadnix.enable = true;
          statix.enable = true;
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
            # Scan the source tree. git-hooks' default args target `gitleaks git`
            # and include `--pre-commit`, which `gitleaks dir` rejects.
            entry = "${pkgs.gitleaks}/bin/gitleaks dir --redact --verbose";
            args = lib.mkForce [];
            pass_filenames = false;
          };
        };
      });

    # Facts each host must keep. They are spelled out here instead of derived
    # from hosts/, so drift in hosts/ or flake builders fails `nix flake check`.
    # These attrsets also name the exported configurations, so none can exist
    # without expectations.
    darwinHosts = {
      personal-mba = {
        username = "chensl";
        hostname = "chensl-mba";
        managesGitAndSsh = true;
        allowsInternalConfig = false;
      };
      work-mbp = {
        username = "bytedance";
        hostname = "CRWQCPJC7G";
        managesGitAndSsh = false;
        allowsInternalConfig = true;
      };
    };

    linuxHomes = {
      "dev@x86_64-linux" = {
        host = "linux-dev";
        system = "x86_64-linux";
        username = "dev";
        managesGit = true;
        allowsInternalConfig = false;
      };
      "dev@aarch64-linux" = {
        host = "linux-dev";
        system = "aarch64-linux";
        username = "dev";
        managesGit = true;
        allowsInternalConfig = false;
      };
    };

    hasInternalRef = home: let
      userSurface = builtins.toJSON {
        inherit (home.home) sessionPath sessionVariables;
        packages = map (p: p.pname or p.name or "") home.home.packages;
        mise = home.programs.mise.globalConfig;
        zsh = {
          inherit (home.programs.zsh) initContent envExtra shellAliases;
        };
        direnv = home.programs.direnv.config;
        git = home.programs.git.settings;
        ssh = home.programs.ssh.settings;
      };
    in
      builtins.match ".*(byted|bytebm).*" userSurface != null;

    evalDarwinConfiguration = pkgs: name: {
      username,
      hostname,
      managesGitAndSsh,
      allowsInternalConfig,
    }: let
      config = self.darwinConfigurations.${name}.config;
      user = config.system.primaryUser;
      home = config.home-manager.users.${user};
      check = lib.assertMsg;
    in
      assert check (user == username) "${name}: unexpected primary user";
      assert check (home.home.username == user) "${name}: Home Manager user differs from primary user";
      assert check (home.home.homeDirectory == config.users.users.${user}.home) "${name}: Home Manager and system home directories differ";
      assert check (config.networking.hostName == hostname) "${name}: unexpected hostname";
      assert check (home.programs.git.enable == managesGitAndSsh) "${name}: unexpected Home Manager Git management";
      assert check (home.programs.ssh.enable == managesGitAndSsh) "${name}: unexpected Home Manager SSH management";
      assert check ((home.home.activation ? backupExistingGitconfig) == managesGitAndSsh) "${name}: unexpected ~/.gitconfig backup hook";
      assert check (home.programs.mise.package == null) "${name}: mise must come from Homebrew on Darwin";
      assert check (!(home.programs.atuin.enable && home.programs.fzf.enable) || home.programs.fzf.historyWidget.command == "") "${name}: fzf historyWidget must be disabled when Atuin owns Ctrl-R";
      assert check (allowsInternalConfig || !(hasInternalRef home)) "${name}: internal company reference leaked into shared configuration";
        pkgs.writeText "eval-${name}" (
          builtins.unsafeDiscardStringContext
          config.system.build.toplevel.drvPath
        );

    evalHomeConfiguration = pkgs: name: {
      host,
      system,
      username,
      managesGit,
      allowsInternalConfig,
    }: let
      cfg = self.homeConfigurations.${name};
      home = cfg.config;
      check = lib.assertMsg;
    in
      assert check (home.home.username == username) "${name}: unexpected Home Manager user";
      assert check (home.home.homeDirectory == "/home/${username}") "${name}: unexpected Home Manager home directory";
      assert check (home.programs.git.enable == managesGit) "${name}: unexpected Home Manager Git management";
      assert check ((home.home.activation ? backupExistingGitconfig) == managesGit) "${name}: unexpected ~/.gitconfig backup hook";
      assert check (home.programs.mise.package != null) "${name}: mise must be installed from nixpkgs on Linux";
      assert check (!(home.programs.atuin.enable && home.programs.fzf.enable) || home.programs.fzf.historyWidget.command == "") "${name}: fzf historyWidget must be disabled when Atuin owns Ctrl-R";
      assert check (allowsInternalConfig || !(hasInternalRef home)) "${name}: internal company reference leaked into shared configuration";
        pkgs.writeText "eval-${host}-${system}" (
          builtins.unsafeDiscardStringContext
          cfg.activationPackage.drvPath
        );
  in {
    darwinConfigurations = lib.genAttrs (builtins.attrNames darwinHosts) mkDarwin;

    homeConfigurations = lib.mapAttrs (_: cfg: mkLinuxHome cfg.host cfg.system) linuxHomes;

    checks = forAllSystems (system: let
      pkgs = nixpkgs-darwin.legacyPackages.${system};
    in
      {pre-commit-check = preCommitChecks.${system};}
      // lib.mapAttrs' (name: expect: {
        name = "${name}-eval";
        value = evalDarwinConfiguration pkgs name expect;
      })
      darwinHosts
      // lib.mapAttrs' (name: expect: {
        name = "${expect.host}-${expect.system}-eval";
        value = evalHomeConfiguration pkgs name expect;
      })
      linuxHomes);

    formatter = forAllSystems (system: nixpkgs-darwin.legacyPackages.${system}.alejandra);

    devShells = forAllSystems (system: let
      pkgs = nixpkgs-darwin.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          alejandra
          deadnix
          nil
          statix
          taplo
          typos
        ];
        inherit (preCommitChecks.${system}) shellHook;
      };
    });
  };
}
