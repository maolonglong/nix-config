{lib, ...}: {
  home.sessionVariables = {
    HOMEBREW_PREFIX = "/opt/homebrew";
    HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
    HOMEBREW_REPOSITORY = "/opt/homebrew";
  };

  home.sessionPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
  ];

  # Installed via Homebrew (`modules/darwin/homebrew.nix`) rather than nixpkgs.
  programs.mise.package = null;

  programs.zsh.initContent = lib.mkOrder 550 ''
    [ -d /opt/homebrew/share/zsh/site-functions ] && fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
  '';
}
