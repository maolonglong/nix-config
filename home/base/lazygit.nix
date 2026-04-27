{pkgs-unstable, ...}: {
  catppuccin.lazygit.enable = true;

  programs.lazygit = {
    enable = true;
    package = pkgs-unstable.lazygit;
    settings = {
      gui = {
        language = "en";
        nerdFontsVersion = "3";
      };
      git = {
        autoFetch = false;
        pagers = [
          {
            pager = "delta --dark --paging=never";
            colorArg = "always";
          }
        ];
        branchLogCmd = "git log --graph --color=always --abbrev-commit --decorate --date=format-local:'%Y-%m-%d %H:%M:%S' --pretty=medium {{branchName}} --";
        allBranchesLogCmds = [
          "git log --graph --all --color=always --abbrev-commit --decorate --date=format-local:'%Y-%m-%d %H:%M:%S' --pretty=medium"
        ];
      };
    };
  };

  programs.zsh.initContent = ''
    lg() {
      export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

      lazygit "$@"

      if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
        cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
        rm -f $LAZYGIT_NEW_DIR_FILE >/dev/null
      fi
    }
  '';
}
