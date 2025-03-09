{
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (inputs) mynur;
in {
  home.packages = with pkgs; [
    git-lfs
    git-extras
  ];

  programs.git = {
    enable = lib.mkDefault true;
    userName = "Shaolong Chen";
    userEmail = "shaolong.chen@outlook.it";
    signing.key = "80263B1A6D611DE4";

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
      branch = {
        sort = "-committerdate";
      };
      color = {
        ui = true;
      };
      column = {
        ui = "auto";
      };
      core = {
        editor = "vim";

        # 单独给大型仓库开
        # git config core.fsmonitor true
        # git config core.untrackedCache true
        # fsmonitor = true;
        # untrackedCache = true;

        # 也许不需要？
        # sshCommand = "/usr/bin/ssh";
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      help = {
        autocorrect = "prompt";
      };
      init = {
        defaultBranch = "main";
      };
      log = {
        date = "format-local:%Y-%m-%d %H:%M:%S";
      };
      merge = {
        conflictstyle = "zdiff3";
      };
      pull = {
        rebase = true;
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
        followTags = true;
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      tag = {
        sort = "version:refname";
      };
    };

    ignores = [
      "*~"
      ".DS_Store"
    ];
  };
}
