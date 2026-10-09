{
  config,
  pkgs,
  ...
}: {
  programs.ssh.enable = false;
  programs.git.enable = false;

  # Not `programs.go`: it would manage ~/Library/Application Support/go/env,
  # which holds this machine's company Go settings.
  home.packages = [
    pkgs.go_1_25
  ];

  programs.mise.globalConfig = {
    env.NPM_CONFIG_REGISTRY = "http://bnpm.byted.org";
    tools = {
      "npm:@vecode-fe/codebase-cli" = "latest";
      "npm:@edenx/proxy" = "latest";
      "npm:@ies/eden-monorepo" = "latest";
      "npm:@larksuite/cli" = "latest";
      "npm:@fission-ai/openspec" = "latest";
    };
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.bytebm/bin"
  ];

  home.sessionVariables = rec {
    GOPATH = "${config.home.homeDirectory}/go";
    GOBIN = "${GOPATH}/bin";
  };
}
