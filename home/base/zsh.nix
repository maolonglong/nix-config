{
  pkgs,
  config,
  ...
}: {
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    localVariables = {
      DISABLE_MAGIC_FUNCTIONS = "true";
      HIST_STAMPS = "yyyy-mm-dd";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "golang"
        "docker"
        "extract"
        "vi-mode"
      ];
      theme = "";
    };

    plugins = [
      {
        name = "nix-zsh-completions";
        src = pkgs.fetchFromGitHub {
          owner = "nix-community";
          repo = "nix-zsh-completions";
          rev = "0.5.1";
          sha256 = "sha256-bgbMc4HqigqgdkvUe/CWbUclwxpl17ESLzCIP8Sz+F8=";
        };
      }
    ];

    envExtra = ''
      [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
      [ "$(command -v fnm)" ] && eval "$(fnm env --use-on-cd --shell zsh)"
      [ -d "/Applications/Obsidian.app/Contents/MacOS" ] && export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
    '';

    initContent = ''
      unalias gog
      unalias gops
      unalias gsu
      unalias gup

      export GPG_TTY=$(tty)
      [ "$(command -v mutagen)" ] && mutagen daemon start
      [ "$(command -v jj)" ] && source <(jj util completion zsh)
    '';

    shellAliases = {
      j = "just";
      rm = "safe-rm";
    };
  };
}
