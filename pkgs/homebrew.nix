_: {
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "none"; # zap;
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
  };
}
