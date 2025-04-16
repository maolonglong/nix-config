{mylib, ...}: {
  imports = mylib.scanPaths ./.;

  # TODO: next release
  #
  # Whether to globally enable shell integration for all supported shells. (Default: true)
  # home.shell.enableShellIntegration = false;
}
