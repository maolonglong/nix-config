{pkgs-unstable, ...}: {
  programs.ssh.enable = false;
  programs.git.enable = false;

  # Configure GOPRIVATE and GOPROXY manually
  programs.go = rec {
    enable = true;
    package = pkgs-unstable.go_1_23;
    goPath = "go";
    goBin = "${goPath}/bin";
    # goPrivate = [
    #   "github.com/maolonglong"
    #   "go.chensl.me"
    # ];
  };

  home.sessionPath = [
    "$GOPATH/bin"
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
