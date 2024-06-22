{pkgs, ...}: {
  home.packages = with pkgs; [
    commitizen # git cz
    scc
  ];
}
