{config, ...}: {
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
      config.whitelist.prefix = ["${config.home.homeDirectory}/.codex/worktrees/"];
    };

    bat = {
      enable = true;
      config = {
        theme = "auto:system";
        theme-dark = "Catppuccin Mocha";
        theme-light = "Catppuccin Latte";
      };
    };

    fzf = rec {
      enable = true;
      defaultCommand = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
      defaultOptions = ["--color=base16"];
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
