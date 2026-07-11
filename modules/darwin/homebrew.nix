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
      autoUpdate = true; # Fetch the newest stable branch of Homebrew's git repo
      upgrade = false; # Upgrade outdated casks, formulae, and App Store apps
      # 'zap': uninstalls all formulae(and related files) not listed in the generated Brewfile
      cleanup = "zap";
    };

    masApps = {};

    taps = [
      "dmtrKovalenko/fff"
    ];

    brews = [
      # `brew install`
      "wget" # download tool
      "curl" # no not install curl via nixpkgs, it's not working well on macOS!
      "aria2" # download tool

      # commands like `gsed` `gtar` are required by some tools
      "gnu-sed"
      "gnu-tar"

      "dmtrKovalenko/fff/fff-mcp"
      "flyctl"
      "rtk"
      "mole"
    ];

    # `brew install --cask`
    casks = [
      "battery"
      "claude-code"
      "ghostty"
      "iterm2"
      "thaw"
      "keepassxc"
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
