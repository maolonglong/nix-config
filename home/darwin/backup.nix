{pkgs, ...}: {
  home.packages = with pkgs; [
    autorestic
    rclone
    restic
  ];

  # TODO: manage configs with agenix?
}
