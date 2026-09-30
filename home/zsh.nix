{
  config,
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.mynur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.shell-safe-rm
  ];

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

    envExtra = ''
      [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
    '';

    initContent = ''
      unalias gog
      unalias gops
      unalias gsu
    '';

    shellAliases = {
      j = "just";
      rm = "safe-rm";
    };
  };
}
