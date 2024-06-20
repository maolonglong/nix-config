{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
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
      theme = ""; # starship
    };

    plugins = [
      {
        name = "nix-zsh-completions";
        src = pkgs.fetchFromGitHub {
          owner = "nix-community";
          repo = "nix-zsh-completions";
          # TODO: 0.5.1
          rev = "0.5.0";
          sha256 = "sha256-DKvCpjAeCiUwD5l6PUW7WlEvM0cNZEOk41IiVXoh9D8";
        };
      }
    ];

    initExtra = ''
      unalias gup
      unalias gops
      unalias gsu

      lg() {
        export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

        lazygit "$@"

        if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
          cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
          rm -f $LAZYGIT_NEW_DIR_FILE >/dev/null
        fi
      }

      [ "$(command -v mutagen)" ] && mutagen daemon start
    '';

    shellAliases = {
      ls = "eza";
      ll = "eza -lhg";
      la = "eza -lhga";
    };
  };
}
