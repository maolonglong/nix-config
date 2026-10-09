{
  catppuccin.lazygit.enable = true;

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        language = "en";
        nerdFontsVersion = "3";
      };
      git = {
        autoFetch = false;
        diffRenderers = [
          {
            command = "delta --dark --paging=never";
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
}
