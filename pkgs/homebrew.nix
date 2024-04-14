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
      "motrix"
      "only-switch"
      "postman"
      "pot"
      "raycast"
      "scroll-reverser"
      "sequel-ace"
      "snipaste"
      "spectacle"
      "the-unarchiver"
      "yesplaymusic"
    ];

    masApps = {
      Xcode = 497799835;
      Bob = 1630034110;
    };
  };
}
