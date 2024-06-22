{pkgs, ...}: let
  gpakosz-tmux = pkgs.fetchFromGitHubWithPatches {
    owner = "gpakosz";
    repo = ".tmux";
    rev = "8e3b90c6c8d0eea022cbcb007dc518503a823765";
    hash = "sha256-Dg94ZMAxaF9okoNWFJymOY+NrNkfjugMZ8P66Se78yU=";
    patches = [./.tmux.conf.local.patch];
  };
in {
  home.file = {
    ".tmux.conf".source = "${gpakosz-tmux}/.tmux.conf";
    ".tmux.conf.local".source = "${gpakosz-tmux}/.tmux.conf.local";
  };
}
