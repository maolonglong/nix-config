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

  programs.mise.globalConfig = {
    env.NPM_CONFIG_REGISTRY = "http://bnpm.byted.org";
    tools = {
      "npm:@vecode-fe/codebase-cli" = "latest";
      "npm:@bytedance-dev/bytedcli" = "latest";
      "npm:@edenx/proxy" = "latest";
      "npm:@ies/eden-monorepo" = "latest";
      "npm:@larksuite/cli" = "latest";
      "npm:@fission-ai/openspec" = "latest";
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
