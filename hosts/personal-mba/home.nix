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
    settings."*" = {
      ForwardAgent = false;
      AddKeysToAgent = "no";
      Compression = false;
      ServerAliveInterval = 0;
      ServerAliveCountMax = 3;
      HashKnownHosts = false;
      UserKnownHostsFile = "~/.ssh/known_hosts";
      ControlMaster = "no";
      ControlPath = "~/.ssh/master-%r@%n:%p";
      ControlPersist = "no";
    };
    settings."github.com" = {
      HostName = "ssh.github.com";
      Port = 443;
      User = "git";
      AddressFamily = "inet";
    };
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
    "${homeDir}/go/bin"
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
