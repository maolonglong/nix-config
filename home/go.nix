{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.go = rec {
    enable = true;
    goPath = "go";
    goBin = "${goPath}/bin";
    goPrivate = [
      "github.com/maolonglong"
      "go.chensl.me"
    ];
  };
}
