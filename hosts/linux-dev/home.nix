{
  config,
  pkgs,
  ...
}: {
  home = {
    packages = [
      pkgs.go_1_27
    ];

    sessionVariables = rec {
      GOPATH = "${config.home.homeDirectory}/go";
      GOBIN = "${GOPATH}/bin";
    };
  };
}
