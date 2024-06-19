{
  config,
  inputs,
  myvars,
  pkgs,
  ...
}: let
  inherit (inputs) agenix;
in {
  imports = [
    agenix.darwinModules.default
  ];

  environment.systemPackages = [
    agenix.packages."${pkgs.system}".default
  ];

  # https://github.com/ryantm/agenix/issues/45#issuecomment-1716862823
  age.identityPaths = [
    # Generate manually via `sudo ssh-keygen -A`
    "/etc/ssh/ssh_host_ed25519_key" # macOS, using the host key for decryption
  ];

  age.secrets = let
    noaccess = {
      mode = "0000";
      owner = "root";
    };
    high_security = {
      mode = "0500";
      owner = "root";
    };
    user_readable = {
      mode = "0500";
      owner = myvars.username;
    };
  in {
    "nix-access-tokens" =
      {
        file = ./nix-access-tokens.age;
      }
      // high_security;
  };
}
