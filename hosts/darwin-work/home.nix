{
  myvars,
  pkgs-unstable,
  ...
}: let
  homeDir = "/Users/${myvars.username}";
in {
  programs.ssh.enable = false;
  programs.git.enable = false;

  # Configure GOPRIVATE and GOPROXY manually
  programs.go = {
    enable = true;
    package = pkgs-unstable.go_1_25;
    env = rec {
      GOPATH = "${homeDir}/go";
      GOBIN = "${GOPATH}/bin";
    };
    # goPrivate = [
    #   "github.com/maolonglong"
    #   "go.chensl.me"
    # ];
  };

  home.sessionPath = [
    "${homeDir}/go/bin"
  ];

  home.sessionVariables = {
    GO111MODULE = "on";
    # GOPROXY = lib.concatStringsSep "|" [
    #   "https://goproxy.cn"
    #   "https://goproxy.io"
    #   "https://proxy.golang.org"
    #   "direct"
    # ];
  };
}
