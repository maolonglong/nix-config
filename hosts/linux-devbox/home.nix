{
  programs.ssh.enable = false;
  programs.git.enable = false;

  # Configure GOPRIVATE and GOPROXY manually
  programs.go = rec {
    enable = true;
    goPath = "go";
    goBin = "${goPath}/bin";
    # goPrivate = [
    #   "github.com/maolonglong"
    #   "go.chensl.me"
    # ];
  };

  programs.starship.settings = {
    username.disabled = true;
    hostname.disabled = true;
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
