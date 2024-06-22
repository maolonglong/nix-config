{myvars, ...}: let
  inherit (myvars) username hostname;
in {
  users.users.${username} = {
    description = "Shaolong Chen";
  };

  networking.hostName = hostname;
  # networking.computerName = hostname;
  # system.defaults.smb.NetBIOSName = hostname;
}
