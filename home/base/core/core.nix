{pkgs, ...}: {
  home.sessionPath = [
    "/usr/local/bin"
    "$HOME/bin"
    "$HOME/.bin"
    "$HOME/.local/bin"
  ];

  home.packages = with pkgs; [
    # Misc
    tldr
    cowsay
    gnupg
    gnumake
    # coreutils

    # search for files by name, faster than find
    fd
    # search for files by its content, replacement of grep
    (ripgrep.override {withPCRE2 = true;})

    # A fast and polyglot tool for code searching, linting, rewriting at large scale
    # supported languages: only some mainstream languages currently(do not support nix/nginx/yaml/toml/...)
    ast-grep

    just # a command runner like make, but simpler
    delta # A viewer for git and diff output
    hyperfine # command-line benchmarking tool
    duf # Disk Usage/Free Utility - a better 'df' alternative
    tmux # Terminal multiplexer
    procs
    tldr
    wrk
  ];

  programs = {
    eza = {
      enable = true;
      # do not enable aliases in zsh!
      enableZshIntegration = false;
      git = true;
      icons = true;
    };

    # TODO: zoxide?
    jump = {
      enable = true;
      bind = "z";
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    bat = {
      enable = true;
      config.theme = "Monokai Extended";
    };

    fzf = rec {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
      fileWidgetCommand = defaultCommand;
      # https://github.com/catppuccin/fzf
      # catppuccin-mocha
      colors = {
        "bg+" = "#313244";
        "bg" = "#1e1e2e";
        "spinner" = "#f5e0dc";
        "hl" = "#f38ba8";
        "fg" = "#cdd6f4";
        "header" = "#f38ba8";
        "info" = "#cba6f7";
        "pointer" = "#f5e0dc";
        "marker" = "#f5e0dc";
        "fg+" = "#cdd6f4";
        "prompt" = "#cba6f7";
        "hl+" = "#f38ba8";
      };
    };

    less.enable = true;
    lesspipe.enable = true;
  };
}