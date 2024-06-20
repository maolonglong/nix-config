{myvars, ...}: let
  inherit (myvars) hostname;
in {
  networking.hostName = hostname;
  # networking.computerName = hostname;
  # system.defaults.smb.NetBIOSName = hostname;
}
