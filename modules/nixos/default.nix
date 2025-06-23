{mylib, ...}: {
  imports =
    (mylib.scanPaths ./.)
    ++ [
      ../base.nix
    ];

  system.stateVersion = "25.05";
}
