{
  config,
  lib,
  myvars,
  pkgs,
  ...
}: let
  catppuccinDelta = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "delta";
    rev = "74b47a345638a2f19b3e5bdb9d7e4984066f9ac7";
    hash = "sha256-NjqqB/BHqduiNWKeksiRZUMfjRUodJlsVu1yaEIZRsM=";
  };
in {
  # `programs.git` writes `~/.config/git/config`; a stray `~/.gitconfig` would
  # silently shadow it. Guarded on `programs.git.enable` so `work-mbp`'s
  # company-managed `~/.gitconfig` is left untouched.
  home.activation.backupExistingGitconfig = lib.mkIf config.programs.git.enable (
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [[ -e "$HOME/.gitconfig" ]]; then
        run mv $VERBOSE_ARG "$HOME/.gitconfig" "$HOME/.gitconfig.bak"
      fi
    ''
  );

  home.packages = [pkgs.git-extras];

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
      ".alma-snapshots"
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    package = pkgs.symlinkJoin {
      name = "delta-auto-theme";
      paths = [pkgs.delta];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/delta \
          --run 'if /usr/bin/defaults read -g AppleInterfaceStyle >/dev/null 2>&1; then set -- --features=catppuccin-mocha "$@"; else set -- --features=catppuccin-latte "$@"; fi' \
          --add-flags "--config ${catppuccinDelta}/catppuccin.gitconfig"
      '';
      inherit (pkgs.delta) meta version;
    };
  };
}
