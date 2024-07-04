{lib, ...}: {
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
          Hostname ssh.github.com
          Port 443
          User git

      Host git-ssh.chensl.me
          ProxyCommand cloudflared access ssh --hostname %h
    '';
  };

  programs.go = rec {
    enable = true;
    goPath = "go";
    goBin = "${goPath}/bin";
    goPrivate = [
      "github.com/maolonglong"
      "go.chensl.me"
    ];
  };

  home.sessionPath = [
    "$GOPATH/bin"
  ];

  home.sessionVariables = {
    GO111MODULE = "on";
    GOPROXY = lib.concatStringsSep "|" [
      "https://goproxy.cn"
      "https://goproxy.io"
      "https://proxy.golang.org"
      "direct"
    ];
  };
}
