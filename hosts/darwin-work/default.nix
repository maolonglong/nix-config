let
  hostname = "QNR3WWC3PW";
in {
  networking.hostName = hostname;
  # networking.computerName = hostname;
  # system.defaults.smb.NetBIOSName = hostname;
}
