{
  lib,
  myvars,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    git-lfs
    git-extras
  ];

  programs.git = {
    enable = lib.mkDefault true;
    signing.key = "80263B1A6D611DE4";

    settings = {
      user = {
        name = myvars.userfullname;
        email = myvars.useremail;
      };
      branch.sort = "-committerdate";
      color.ui = true;
      column.ui = "auto";
      core.editor = "vim";
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      help.autocorrect = "prompt";
      init.defaultBranch = "main";
      log.date = "format-local:%Y-%m-%d %H:%M:%S";
      merge.conflictstyle = "zdiff3";
      pull.rebase = true;
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
      tag.sort = "version:refname";
    };

    lfs.enable = true;

    ignores = [
      "*~"
      ".DS_Store"
      "**/*.local.*"
    ];
  };

  catppuccin.delta.enable = true;

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
