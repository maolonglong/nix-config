{pkgs, ...}: {
  home.packages = with pkgs; [
    commitizen
    scc
  ];
}
