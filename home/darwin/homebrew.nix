{
  programs.zsh = {
    envExtra = ''
      [ -f "/opt/homebrew/bin/" ] && eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    initExtraBeforeCompInit = ''
      [ "$(command -v brew)" ] && fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
    '';

    initExtra = ''
      export GPG_TTY=$(tty)
    '';
  };

  home.sessionPath = [
    "/opt/homebrew/bin"
  ];
}
