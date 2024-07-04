{
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (inputs) mynur;
in {
  home.packages = [pkgs.git-lfs];

  programs.git = {
    enable = lib.mkDefault true;
    userName = lib.mkDefault "Shaolong Chen";
    userEmail = lib.mkDefault "shaolong.chen@outlook.it";

    lfs.enable = true;

    includes = [
      {path = "${mynur.legacyPackages.${pkgs.system}.catppuccinThemes.delta}/catppuccin.gitconfig";}
    ];
    delta = {
      enable = true;
      options = {
        features = "catppuccin-mocha";
      };
    };

    extraConfig = {
      core = {
        editor = "vim";
        # 也许不需要？
        # sshCommand = "/usr/bin/ssh";
      };
      color = {
        ui = true;
      };
      push = {
        default = "simple";
      };
      pull = {
        rebase = true;
      };
      init = {
        defaultBranch = "main";
      };
      fetch = {
        prune = true;
      };
      log = {
        date = "format-local:%Y-%m-%d %H:%M:%S";
      };
    };

    ignores = [
      "*~"
      ".DS_Store"
    ];
  };
}
