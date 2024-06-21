{lib, ...}: {
  programs.git = {
    enable = true;
    userName = lib.mkDefault "Shaolong Chen";
    userEmail = lib.mkDefault "shaolong.chen@outlook.it";

    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        # TODO: catppuccin_mocha?
        syntax-theme = "Monokai Extended";
      };
    };

    extraConfig = {
      core = {
        editor = "vim";
        # 也许不需要？
        # sshCommand = "/usr/bin/ssh";
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
      log = {
        date = "format-local:%Y-%m-%d %H:%M:%S";
      };
    };

    ignores = [
      "*~"
      ".DS_Store"
    ];
  };
}