{...}: {
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap"; # none;
      autoUpdate = true;
      upgrade = true;
    };

    taps = [
      "localsend/localsend"
      "pot-app/homebrew-tap"
    ];

    brews = [
      # TODO: move to nix
      "kcov"
    ];

    casks = [
      "element"
      "iterm2"
      "keepassxc"
      "keycastr"
      "localsend"
      "logseq"
      "monitorcontrol"
      "only-switch"
      "postman"
      "pot"
      "raycast"
      "scroll-reverser"
      "sequel-ace"
      "sfm"
      "snipaste"
      "spectacle"
      "the-unarchiver"
      "yesplaymusic"
    ];

    masApps = {
      Xcode = 497799835;
    };
  };
}
