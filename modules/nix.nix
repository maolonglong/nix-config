{
  inputs,
  pkgs,
  ...
}: {
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nixUnstable;
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];

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
}
