{
  config,
  pkgs,
  lib,
  vars,
  ...
}: {
  age.secrets = {
    rclone-config = {
      file = ../secrets/rclone-config.age;
      path = "${vars.homeDir}/.config/rclone/rclone.conf";
    };
    restic-passwd = {
      file = ../secrets/restic-passwd.age;
    };
  };

  home.sessionVariables = {
    RESTIC_REPOSITORY = "rclone:b2:chensl-backup/restic";
    RESTIC_PASSWORD_FILE = config.age.secrets.restic-passwd.path;
  };
}
