{
  mylib,
  myvars,
  ...
}: {
  home.homeDirectory = "/home/${myvars.username}";
  imports =
    (mylib.scanPaths ./.)
    ++ [
      ../base/core
      ../base/tui
      ../base/gui
      ../base/home.nix
    ];
}
