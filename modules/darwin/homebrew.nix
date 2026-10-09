{lib, ...}: let
  # Any mirror that follows the tuna/bfsu/nju layout works here.
  mirror = "https://mirrors.bfsu.edu.cn";
  homebrewMirrorEnv = {
    HOMEBREW_API_DOMAIN = "${mirror}/homebrew-bottles/api";
    HOMEBREW_BOTTLE_DOMAIN = "${mirror}/homebrew-bottles";
    HOMEBREW_BREW_GIT_REMOTE = "${mirror}/git/homebrew/brew.git";
    HOMEBREW_CORE_GIT_REMOTE = "${mirror}/git/homebrew/homebrew-core.git";
    HOMEBREW_PIP_INDEX_URL = "https://pypi.tuna.tsinghua.edu.cn/simple";
  };

  homebrewEnvScript =
    lib.concatMapAttrsStringSep "\n" (name: value: "export ${name}=${value}") homebrewMirrorEnv;
in {
  environment.variables = homebrewMirrorEnv;

  system.activationScripts.homebrew.text = lib.mkBefore ''
    echo >&2 '${homebrewEnvScript}'
    ${homebrewEnvScript}
  '';

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
      "rjyo/moshi"
    ];

    brews = [
      # `brew install`
      "wget" # download tool
      "curl" # no not install curl via nixpkgs, it's not working well on macOS!
      "aria2" # download tool

      # commands like `gsed` `gtar` are required by some tools
      "gnu-sed"
      "gnu-tar"

      "pango" # native libs for WeasyPrint (kami PDF rendering)

      "dmtrKovalenko/fff/fff-mcp"
      "rjyo/moshi/moshi-hook"
      "flyctl"
      "rtk"
      "mise"
      "mole"
    ];

    # `brew install --cask`
    casks = [
      "battery"
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
