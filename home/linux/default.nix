{config, ...}: {
  # Re-prepend Nix profile bins in `hm-session-vars.sh` so `/etc/profile` resets
  # on remote Linux devboxes do not shadow Home Manager or Nix tools.
  home.sessionPath = [
    "${config.home.profileDirectory}/bin"
    "/nix/var/nix/profiles/default/bin"
  ];
}
