{pkgs, ...}: let
  gpakoszTmux = pkgs.stdenv.mkDerivation {
    pname = "gpakosz-tmux";
    version = "8e3b90c6c8d0eea022cbcb007dc518503a823765";
    src = pkgs.fetchFromGitHub {
      owner = "gpakosz";
      repo = ".tmux";
      rev = "8e3b90c6c8d0eea022cbcb007dc518503a823765";
      hash = "sha256-Dg94ZMAxaF9okoNWFJymOY+NrNkfjugMZ8P66Se78yU=";
    };
    patches = [./.tmux.conf.local.patch];
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -R . $out/
      runHook postInstall
    '';
  };
in {
  home.file = {
    ".tmux.conf".source = "${gpakoszTmux}/.tmux.conf";
    ".tmux.conf.local".source = "${gpakoszTmux}/.tmux.conf.local";
  };

  home.packages = with pkgs; [
    tmux
    perl
  ];
}
