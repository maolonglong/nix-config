{
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs) agenix mysecrets;
in {
  imports = [
    agenix.darwinModules.default
  ];

  environment.systemPackages = [
    agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  age.secrets = {
    nix-access-tokens = {
      file = "${mysecrets}/nix-access-tokens.age";
      mode = "444";
    };
    rclone-config = {
      file = "${mysecrets}/rclone-config.age";
      mode = "444";
    };
    restic-config = {
      file = "${mysecrets}/restic-config.age";
      mode = "444";
    };
  };
}
