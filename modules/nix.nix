{
  inputs,
  vars,
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

      trusted-users = [vars.username];
    };

    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 0;
        Minute = 0;
      };
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
}
