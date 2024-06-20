{
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        language = "en";
        nerdFontsVersion = "3";
        theme = {
          selectedLineBgColor = ["reverse"];
          selectedRangeBgColor = ["reverse"];
        };
      };
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
        branchLogCmd = "git log --graph --color=always --abbrev-commit --decorate --date=format-local:'%Y-%m-%d %H:%M:%S' --pretty=medium {{branchName}} --";
        allBranchesLogCmd = "git log --graph --all --color=always --abbrev-commit --decorate --date=format-local:'%Y-%m-%d %H:%M:%S' --pretty=medium";
      };
    };
  };
}
