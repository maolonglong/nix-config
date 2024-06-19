{
  myvars,
  pkgs,
  ...
}: {
  home = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    inherit (myvars) username;
    homeDirectory = myvars.homeDir;

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
      fetchWithPatch = {
        owner,
        repo,
        rev,
        hash,
        patches,
      }:
        pkgs.stdenv.mkDerivation {
          pname = repo;
          version = rev;
          src = pkgs.fetchFromGitHub {
            inherit owner repo rev hash;
          };
          inherit patches;
          installPhase = ''
            runHook preInstall
            mkdir -p $out
            cp -R . $out/
            runHook postInstall
          '';
        };
      gpakosz-tmux = fetchWithPatch {
        owner = "gpakosz";
        repo = ".tmux";
        rev = "8e3b90c6c8d0eea022cbcb007dc518503a823765";
        hash = "sha256-Dg94ZMAxaF9okoNWFJymOY+NrNkfjugMZ8P66Se78yU=";
        patches = [../rc/.tmux.conf.local.patch];
      };
      amix-vimrc = pkgs.fetchFromGitHub {
        owner = "amix";
        repo = "vimrc";
        rev = "63419d6513fd10b42ad1fcc1ed80ca8c8c1508ec";
        hash = "sha256-mMoo4SEBhi8KlVH8ehwwKqGO3gAZuHjTtDwSc4c5vj4=";
      };
    in {
      ".ssh/config".source = ../rc/.ssh/config;
      ".vimrc".source = "${amix-vimrc}/vimrcs/basic.vim";
      ".tmux.conf".source = "${gpakosz-tmux}/.tmux.conf";
      ".tmux.conf.local".source = "${gpakosz-tmux}/.tmux.conf.local";
      ".cargo/config".text =
        (builtins.readFile ../rc/.cargo/config)
        + ''
          [build]
          rustc-wrapper = "${pkgs.sccache}/bin/sccache"
        '';
      ".config/alacritty/alacritty.toml".source = ../rc/.config/alacritty/alacritty.toml;
    };
  };

  programs = {
    home-manager.enable = true;

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        time = {
          disabled = true;
          format = ''🕙[\[ $time \]]($style)'';
          time_format = "%T";
        };
      };
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

    less.enable = true;
    lesspipe.enable = true;
  };

  imports = [
    ./alacritty.nix
    ./fzf.nix
    ./git.nix
    ./go.nix
    ./helix.nix
    ./lazygit.nix
    # TODO: ...
    # ./restic.nix
    # TODO: vscode 太经常变更了，考虑不用 nix 配置
    # ./vscode
    ./zellij.nix
    ./zsh.nix
  ];
}
