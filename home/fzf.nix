{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.fzf = rec {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "${pkgs.fd}/bin/fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
    fileWidgetCommand = defaultCommand;
  };
}
