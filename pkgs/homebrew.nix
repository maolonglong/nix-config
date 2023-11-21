_: {
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

    brews = [];

    casks = [
      "element"
      "iterm2"
      "keycastr"
      "logseq"
      "monitorcontrol"
      "only-switch"
      "postman"
      "raycast"
      "scroll-reverser"
      "sequel-ace"
      "snipaste"
      "spectacle"
      "the-unarchiver"
      "keepassxc"
      "sfm"
      "localsend"
      "yesplaymusic"
    ];

    masApps = {
      "Bob - 翻译和 OCR 工具" = 1630034110;
      Xcode = 497799835;
    };
  };
}
