{
  self,
  nixpkgs,
  pre-commit-hooks,
  ...
} @ inputs: let
  inherit (nixpkgs) lib;
  mylib = import ../lib {inherit lib;};

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

  # This is the args for all the haumea modules in this folder.
  args = {inherit inputs lib mylib genSpecialArgs mkDarwin;};

  # modules for each supported system
  nixosSystems = {};
  darwinSystems = {
    aarch64-darwin = [
      (import ./aarch64-darwin/chensl-mba args)
    ];
  };
  allSystems = nixosSystems // darwinSystems;
  allSystemNames = builtins.attrNames allSystems;
  nixosSystemValues = builtins.concatMap lib.id (builtins.attrValues nixosSystems);
  darwinSystemValues = builtins.concatMap lib.id (builtins.attrValues darwinSystems);
  allSystemValues = nixosSystemValues ++ darwinSystemValues;

  # Helper function to generate a set of attributes for each system
  forAllSystems = func: (lib.genAttrs allSystemNames func);
in {
  # NixOS Hosts
  nixosConfigurations =
    lib.attrsets.mergeAttrsList (map (it: it.nixosConfigurations or {}) nixosSystemValues);

  # macOS Hosts
  darwinConfigurations =
    lib.attrsets.mergeAttrsList (map (it: it.darwinConfigurations or {}) darwinSystemValues);

  # Eval Tests for all NixOS & darwin systems.
  evalTests = lib.lists.all (it: it.evalTests == {}) allSystemValues;

  devShells = forAllSystems (
    system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [
          alejandra
          nil
          typos
        ];
        shellHook = self.checks.${system}.pre-commit-check.shellHook;
      };
    }
  );

  # Format the nix code in this flake
  formatter = forAllSystems (
    # alejandra is a nix formatter with a beautiful output
    system: nixpkgs.legacyPackages.${system}.alejandra
  );

  checks = forAllSystems (
    system: {
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
          # prettier = {
          #   enable = true;
          #   settings = {
          #     write = true; # Automatically format files
          #     configPath = "./.prettierrc.yaml"; # relative to the flake root
          #   };
          # };
          # deadnix.enable = true; # detect unused variable bindings in `*.nix`
          # statix.enable = true; # lints and suggestions for Nix code(auto suggestions)
        };
      };
    }
  );
}
