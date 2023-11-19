{
  config,
  pkgs,
  lib,
  ...
}: {
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
          pager = "${pkgs.delta}/bin/delta --dark --paging=never";
        };
      };
    };
  };
}
