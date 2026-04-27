{lib, ...}: {
  programs.zsh = {
    envExtra = ''
      [ -x "/opt/homebrew/bin/brew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    initContent = lib.mkOrder 550 ''
      [ "$(command -v brew)" ] && fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
    '';
  };

  home.sessionPath = [
    "/opt/homebrew/bin"
  ];
}
