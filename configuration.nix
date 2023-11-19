{
  pkgs,
  lib,
  inputs,
  vars,
  ...
}: {
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nixUnstable;

    settings = {
      # Necessary for using flakes on this system.
      experimental-features = "nix-command flakes";

      # https://mirrors.sjtug.sjtu.edu.cn/docs/nix-channels/store
      substituters = ["https://mirror.sjtu.edu.cn/nix-channels/store"];
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 5d";
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  users.users.${vars.username} = {
    name = vars.username;
    home = vars.homeDir;
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = vars.arch;

  imports = [
    ./pkgs/fonts.nix
    ./pkgs/system.nix
    ./pkgs/homebrew.nix
  ];
}
