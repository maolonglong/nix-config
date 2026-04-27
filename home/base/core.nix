{
  inputs,
  pkgs,
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
      tldr
      cowsay
      gnupg
      gnumake
      fd
      (ripgrep.override {withPCRE2 = true;})
      ast-grep
      just
      hyperfine
      duf
      procs
      wrk
    ]
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
        "--disable-ctrl-r"
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
      enableZshIntegration = true;
      defaultCommand = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
      fileWidgetCommand = defaultCommand;
    };

    less.enable = true;
    lesspipe.enable = true;
  };
}
