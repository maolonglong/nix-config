{
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}: let
  inherit (inputs) mynur;
in {
  home.sessionPath = [
    "/usr/local/bin"
    "$HOME/bin"
    "$HOME/.bin"
    "$HOME/.bun/bin"
    "$HOME/.claude/local"
    "$HOME/.local/share/mise/shims"
  ];

  home.packages = with pkgs;
    [
      tldr
      cowsay
      gnupg
      gnumake
      fd
      (ripgrep.override {withPCRE2 = true;})
      just
      hyperfine
      duf
      procs
      wrk
    ]
    ++ (with pkgs-unstable; [
      ast-grep
    ])
    ++ (with mynur.legacyPackages.${pkgs.stdenv.hostPlatform.system}; [
      shell-safe-rm
    ]);

  catppuccin = {
    atuin.enable = true;
    bat.enable = true;
    fzf.enable = true;
  };

  programs = {
    atuin = {
      enable = true;
      enableZshIntegration = true;
      flags = [
        "--disable-up-arrow"
      ];
    };

    eza.enable = true;

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    bat.enable = true;

    fzf = rec {
      enable = true;
      # Home Manager loads fzf at order 910 and Atuin at the default order 1000,
      # so Atuin initializes later and owns Ctrl-R while fzf keeps its other widgets.
      enableZshIntegration = true;
      defaultCommand = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
      fileWidgetCommand = defaultCommand;
    };

    less.enable = true;
    lesspipe.enable = true;
  };
}
