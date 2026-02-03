{
  pkgs,
  inputs,
  ...
}: let
  inherit (inputs) mynur;
in {
  home.sessionPath = [
    "/usr/local/bin"
    "$HOME/bin"
    "$HOME/.bin"
    "$HOME/.local/bin"
    "$HOME/.bun/bin"
    "$HOME/.claude/local"
  ];

  home.packages = with pkgs;
    [
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
      hyperfine # command-line benchmarking tool
      duf # Disk Usage/Free Utility - a better 'df' alternative
      procs
      wrk
    ]
    ++ (with mynur.legacyPackages.${pkgs.stdenv.hostPlatform.system}; [
      shell-safe-rm
    ]);

  catppuccin = {
    bat.enable = true;
    fzf.enable = true;
  };

  programs = {
    eza.enable = true;

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      # config = {
      #   global = {
      #     load_dotenv = true;
      #   };
      # };
    };

    bat.enable = true;

    fzf = rec {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
      fileWidgetCommand = defaultCommand;
    };

    less.enable = true;
    lesspipe.enable = true;
  };
}
