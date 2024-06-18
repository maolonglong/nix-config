{
  inputs,
  vars,
  pkgs,
  ...
}: {
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nixVersions.latest;
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    settings = {
      # Necessary for using flakes on this system.
      experimental-features = "nix-command flakes";

      # https://mirrors.sjtug.sjtu.edu.cn/docs/nix-channels/store
      # substituters = [
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      # "https://mirror.sjtu.edu.cn/nix-channels/store"
      # "https://cache.garnix.io"
      # "https://nix-community.cachix.org"
      # "https://devenv.cachix.org"
      # "https://maolonglong.cachix.org"
      # ];
      # trusted-public-keys = [
      # "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      # "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      # "maolonglong.cachix.org-1:da0YR8cbEEEtWhqWhz1AF5S6Awl+is2PV6Y34Si7Ivg="
      # ];

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
