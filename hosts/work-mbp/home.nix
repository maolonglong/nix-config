{
  myvars,
  pkgs-unstable,
  ...
}: let
  homeDir = "/Users/${myvars.username}";
in {
  programs.ssh.enable = false;
  programs.git.enable = false;

  home.packages = [
    pkgs-unstable.go_1_25
  ];

  programs.go = {
    enable = false;
    package = pkgs-unstable.go_1_25;
    env = rec {
      GOPATH = "${homeDir}/go";
      GOBIN = "${GOPATH}/bin";
    };
  };

  home.sessionPath = [
    "${homeDir}/go/bin"
  ];

  home.sessionVariables = rec {
    GO111MODULE = "on";
    GOPATH = "${homeDir}/go";
    GOBIN = "${GOPATH}/bin";
  };
}
