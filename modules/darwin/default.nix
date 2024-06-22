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

  system = {
    # Set Git commit hash for darwin-version.
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = myvars.system;
}
