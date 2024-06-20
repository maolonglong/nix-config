{
  myvars,
  outputs,
  ...
}: let
  inherit (myvars) hostname username;
in
  outputs.darwinConfigurations.${hostname}.config.home-manager.users.${username}.home.homeDirectory
