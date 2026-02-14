{
  lib,
  myvars,
  ...
}: let
  homeDir = "/Users/${myvars.username}";
in {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      forwardAgent = false;
      addKeysToAgent = "no";
      compression = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    };
    extraConfig = ''
      Host github.com
          Hostname ssh.github.com
          Port 443
          User git
    '';
  };

  programs.go = {
    enable = true;
    env = rec {
      GOPATH = "${homeDir}/go";
      GOBIN = "${GOPATH}/bin";
      GOPRIVATE = lib.concatStringsSep "," [
        "github.com/maolonglong"
        "go.chensl.me"
      ];
    };
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
