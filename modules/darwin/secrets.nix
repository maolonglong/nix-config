{
  config,
  inputs,
  myvars,
  pkgs,
  ...
}: let
  inherit (inputs) agenix mysecrets;
in {
  imports = [
    agenix.darwinModules.default
  ];

  # `!include` below ignores a missing file without failing, so log boot-time
  # decryption output instead of failing silently into GitHub rate limits.
  launchd.daemons."activate-agenix".serviceConfig = {
    StandardErrorPath = "/Library/Logs/org.nixos.activate-agenix.stderr.log";
    StandardOutPath = "/Library/Logs/org.nixos.activate-agenix.stdout.log";
  };

  environment.systemPackages = [
    agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  age.secrets = {
    nix-access-tokens = {
      file = "${mysecrets}/nix-access-tokens.age";
      owner = myvars.username;
      mode = "0400";
    };
  };

  nix.extraOptions = ''
    !include ${config.age.secrets.nix-access-tokens.path}
  '';
}
