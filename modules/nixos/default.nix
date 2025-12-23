{mylib, ...}: {
  imports =
    (mylib.scanPaths ./.)
    ++ [
      ../base
    ];

  system.stateVersion = "25.11";
}
