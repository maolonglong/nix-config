{lib, ...}: {
  programs.zsh = {
    envExtra = ''
      [ -f "/opt/homebrew/bin/" ] && eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    initContent = lib.mkOrder 550 ''
      [ "$(command -v brew)" ] && fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
    '';
  };

  home.sessionPath = [
    "/opt/homebrew/bin"
  ];
}
