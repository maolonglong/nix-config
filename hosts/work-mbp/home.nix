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

  programs.mise.globalConfig.tools = {
    "npm:@vecode-fe/codebase-cli" = "latest";
    "npm:@bytedance-dev/bytedcli" = "latest";
    "npm:@edenx/proxy" = "latest";
    "npm:@ies/eden-monorepo" = "latest";
    "npm:@larksuite/cli" = "latest";
    "npm:@fission-ai/openspec" = "latest";
  };

  home.file.".npmrc".text = ''
    @vecode-fe:registry=http://bnpm.byted.org
    @bytedance-dev:registry=http://bnpm.byted.org
    @edenx:registry=http://bnpm.byted.org
    @ies:registry=http://bnpm.byted.org
  '';

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
