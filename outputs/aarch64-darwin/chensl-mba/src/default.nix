{
  mylib,
  myvars,
  mkDarwin,
  ...
}: let
  inherit (myvars) hostname;
  modules = {
    darwin-modules = map mylib.relativeToRoot [
      "secrets/darwin.nix"
      "configuration.nix"
      "hosts/darwin-${hostname}"
    ];
    home-modules = map mylib.relativeToRoot [
      "home"
    ];
  };
in {
  darwinConfigurations.${hostname} = mkDarwin myvars modules;
}
