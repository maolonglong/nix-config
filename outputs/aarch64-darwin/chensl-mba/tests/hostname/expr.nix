{
  myvars,
  outputs,
  ...
}: let
  inherit (myvars) hostname;
in
  outputs.darwinConfigurations.${hostname}.config.networking.hostName
