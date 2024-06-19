let
  publicKeys = {
    personal = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnRaGjCx/MwpJP1oo2sq8TPNf8CCJ7LBKnycPezALr1";
    chensl-mba = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO0zpLxxhMJzJ10J6NETwC5VKkZZvJtkFkjNYRo0Ta+D";
  };
  allKeys = builtins.attrValues publicKeys;
in {
  "rclone-config.age".publicKeys = allKeys;
  "restic-passwd.age".publicKeys = allKeys;
  "nix-access-tokens.age".publicKeys = allKeys;
}
