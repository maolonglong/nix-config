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
    ];

    brews = [
      "flyctl"
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
