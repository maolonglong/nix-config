{
  config,
  pkgs,
  lib,
  vars,
  ...
}: {
  home = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    inherit (vars) username;
    homeDirectory = vars.homeDir;

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.05";

    sessionPath = [
      # "/run/current-system/sw/bin"

      "/opt/homebrew/bin"
      "/usr/local/bin"
      "$GOPATH/bin"
      "$HOME/bin"
      "$HOME/.bin"
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
    ];

    sessionVariables = {
      EDITOR = "vim";
      GIT_SSH_COMMAND = "/usr/bin/ssh";
      HOMEBREW_API_DOMAIN = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api";
      HOMEBREW_BOTTLE_DOMAIN = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles";
      HOMEBREW_BREW_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git";
      HOMEBREW_CORE_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git";
      HOMEBREW_PIP_INDEX_URL = "https://pypi.tuna.tsinghua.edu.cn/simple";
    };

    file = let
      gpakosz-tmux = pkgs.fetchFromGitHub {
        owner = "gpakosz";
        repo = ".tmux";
        rev = "fd1bbb56148101f4b286ddafd98f2ac2dcd69cd8";
        sha256 = "sha256-LkoRWds7PHsteJCDvsBpZ80zvlLtFenLU3CPAxdEHYA";
      };
      amix-vimrc = pkgs.fetchFromGitHub {
        owner = "amix";
        repo = "vimrc";
        rev = "63419d6513fd10b42ad1fcc1ed80ca8c8c1508ec";
        sha256 = "sha256-mMoo4SEBhi8KlVH8ehwwKqGO3gAZuHjTtDwSc4c5vj4=";
      };
    in {
      ".ssh/config".source = ../rc/.ssh/config;
      ".vimrc".source = "${amix-vimrc}/vimrcs/basic.vim";
      ".tmux.conf".source = "${gpakosz-tmux}/.tmux.conf";
      ".tmux.conf.local".source = ../rc/.tmux.conf.local;
      ".cargo/config".text =
        (builtins.readFile ../rc/.cargo/config)
        + ''
          [build]
          rustc-wrapper = "${pkgs.sccache}/bin/sccache"
        '';
    };
  };

  programs = {
    home-manager.enable = true;

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

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
  };

  imports = [
    ./zsh.nix
    ./go.nix
    ./git.nix
    ./fzf.nix
    ./lazygit.nix
    ./vscode.nix
  ];
}
