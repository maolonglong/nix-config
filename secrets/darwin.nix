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

  environment.systemPackages = [
    agenix.packages."${pkgs.system}".default
  ];

  # https://github.com/ryantm/agenix/issues/45#issuecomment-1716862823
  age.identityPaths = [
    # Generate manually via `sudo ssh-keygen -A`
    "/etc/ssh/ssh_host_ed25519_key" # macOS, using the host key for decryption
  ];

  age.secrets = {
    "nix-access-tokens" = {
      file = "${mysecrets}/nix-access-tokens.age";
      mode = "444";
    };
  };
}
