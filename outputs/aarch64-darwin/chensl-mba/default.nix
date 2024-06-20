{
  lib,
  inputs,
  ...
} @ args: let
  inherit (inputs) haumea;

  myvars = {
    system = "aarch64-darwin";
    username = "chensl";
    homeDir = "/Users/chensl";
    hostname = "chensl-mba";
  };

  # Contains all the flake outputs of this system architecture.
  data = haumea.lib.load {
    src = ./src;
    inputs = args // {inherit myvars;};
  };

  outputs = {
    inherit (data.default) darwinConfigurations;
  };
in
  outputs
  // {
    # NixOS's unit tests.
    evalTests = haumea.lib.loadEvalTests {
      src = ./tests;
      inputs = args // {inherit myvars outputs;};
    };
  }
