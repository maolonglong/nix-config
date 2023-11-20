{
  pkgs,
  lib,
  inputs,
  vars,
  ...
}: {
  users.users.${vars.username} = {
    name = vars.username;
    home = vars.homeDir;
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  system = {
    # Set Git commit hash for darwin-version.
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = vars.arch;

  imports = [
    ./modules/fonts.nix
    ./modules/nix.nix
    ./modules/system.nix

    ./pkgs/homebrew.nix
    ./pkgs/system.nix
  ];
}
