let
  personal = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnRaGjCx/MwpJP1oo2sq8TPNf8CCJ7LBKnycPezALr1";
in {
  "rclone-config.age".publicKeys = [personal];
  "restic-passwd.age".publicKeys = [personal];
}
