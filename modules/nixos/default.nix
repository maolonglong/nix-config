{
  inputs,
  myvars,
  mylib,
  ...
}: {
  imports =
    (mylib.scanPaths ./.)
    ++ [
      ../base.nix
    ];

  system.stateVersion = "24.05";
}
