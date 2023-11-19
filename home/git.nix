{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Shaolong Chen";
    userEmail = "shaolong.chen@outlook.it";

    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        syntax-theme = "Monokai Extended";
      };
    };

    extraConfig = {
      core = {
        editor = "vim";
        sshCommand = "/usr/bin/ssh";
      };
      color = {
        ui = true;
      };
      push = {
        default = "simple";
      };
      pull = {
        rebase = true;
      };
      init = {
        defaultBranch = "main";
      };
      fetch = {
        prune = true;
      };
    };

    ignores = [
      "*~"
      ".DS_Store"
    ];
  };
}
