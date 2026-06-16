{
  config,
  lib,
  ...
}: let
  homebrewMirrorEnv = {
    # tuna mirror
    # HOMEBREW_API_DOMAIN = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api";
    # HOMEBREW_BOTTLE_DOMAIN = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles";
    # HOMEBREW_BREW_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git";
    # HOMEBREW_CORE_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git";
    # HOMEBREW_PIP_INDEX_URL = "https://pypi.tuna.tsinghua.edu.cn/simple";

    # bfsu mirror
    HOMEBREW_API_DOMAIN = "https://mirrors.bfsu.edu.cn/homebrew-bottles/api";
    HOMEBREW_BOTTLE_DOMAIN = "https://mirrors.bfsu.edu.cn/homebrew-bottles";
    HOMEBREW_BREW_GIT_REMOTE = "https://mirrors.bfsu.edu.cn/git/homebrew/brew.git";
    HOMEBREW_CORE_GIT_REMOTE = "https://mirrors.bfsu.edu.cn/git/homebrew/homebrew-core.git";
    HOMEBREW_PIP_INDEX_URL = "https://pypi.tuna.tsinghua.edu.cn/simple";

    # nju mirror
    # HOMEBREW_API_DOMAIN = "https://mirror.nju.edu.cn/homebrew-bottles/api";
    # HOMEBREW_BOTTLE_DOMAIN = "https://mirror.nju.edu.cn/homebrew-bottles";
    # HOMEBREW_BREW_GIT_REMOTE = "https://mirror.nju.edu.cn/git/homebrew/brew.git";
    # HOMEBREW_CORE_GIT_REMOTE = "https://mirror.nju.edu.cn/git/homebrew/homebrew-core.git";
    # HOMEBREW_PIP_INDEX_URL = "https://pypi.tuna.tsinghua.edu.cn/simple";
  };

  homebrewEnvScript =
    lib.attrsets.foldlAttrs
    (acc: name: value: acc + "\nexport ${name}=${value}")
    ""
    homebrewMirrorEnv;
in {
  environment.variables =
    {
      TERMINFO_DIRS =
        map (path: path + "/share/terminfo") config.environment.profiles
        ++ ["/usr/share/terminfo"];
      EDITOR = "vim";
    }
    // homebrewMirrorEnv;

  system.activationScripts.homebrew.text = lib.mkBefore ''
    echo >&2 '${homebrewEnvScript}'
    ${homebrewEnvScript}
  '';

  programs.zsh.enable = true;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      extraFlags = [ "--force-cleanup" ];
    };
    masApps = {};
    taps = [
      "dmtrKovalenko/fff"
      "localsend/localsend"
      "tw93/tap"
    ];
    brews = [
      "dmtrKovalenko/fff/fff-mcp"
      "flyctl"
      "rtk"
      "tw93/tap/mole"
    ];
    casks = [
      "battery"
      "claude-code"
      "iterm2"
      "thaw"
      "keepassxc"
      "librewolf"
      "localsend"
      "logseq"
      "monitorcontrol"
      "only-switch"
      "orbstack"
      "postman"
      "raycast"
      "rectangle"
      "scroll-reverser"
      "sequel-ace"
      "snipaste"
      "the-unarchiver"
      "visual-studio-code"
    ];
  };
}
