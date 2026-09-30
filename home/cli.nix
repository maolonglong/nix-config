{
  catppuccin = {
    atuin.enable = true;
    bat.enable = true;
    fzf.enable = true;
  };

  programs = {
    atuin = {
      enable = true;
      flags = [
        "--disable-up-arrow"
      ];
    };

    eza.enable = true;

    zoxide.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    bat.enable = true;

    fzf = rec {
      enable = true;
      defaultCommand = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
      fileWidget.command = defaultCommand;
      # Let Atuin own Ctrl-R while fzf keeps its other widgets. An empty command
      # makes fzf (>= 0.66) skip its Ctrl-R binding; Home Manager also sources
      # Atuin after fzf, and warns at eval time if both still claim Ctrl-R.
      historyWidget.command = "";
    };

    less.enable = true;
    lesspipe.enable = true;
  };
}
