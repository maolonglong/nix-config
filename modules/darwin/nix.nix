{myvars, ...}: {
  nix = {
    gc.automatic = false;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [myvars.username];
      substituters = [
        # cache mirror located in China
        # status: https://mirrors.ustc.edu.cn/status/
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        # status: https://mirror.sjtu.edu.cn/
        # "https://mirror.sjtu.edu.cn/nix-channels/store"
        # others
        # "https://mirrors.sustech.edu.cn/nix-channels/store"
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"

        "https://nix-community.cachix.org"
        "https://catppuccin.cachix.org"
        # my own cache server, currently not used.
        # "https://maolonglong.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
        "maolonglong.cachix.org-1:da0YR8cbEEEtWhqWhz1AF5S6Awl+is2PV6Y34Si7Ivg="
      ];
      builders-use-substitutes = true;
      auto-optimise-store = false;
    };
  };

  nixpkgs = {
    hostPlatform = myvars.system;
    flake = {
      setFlakeRegistry = true;
      setNixPath = true;
    };
  };
}
