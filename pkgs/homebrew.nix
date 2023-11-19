_: {
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "none"; # zap;
      autoUpdate = true;
      upgrade = true;
    };

    taps = [];

    brews = [];

    casks = [
      "element"
      "iterm2"
      "keycastr"
      "logseq"
      "monitorcontrol"
      "only-switch"
      "postman"
      "postman"
      "raycast"
      "scroll-reverser"
      "sequel-ace"
      "snipaste"
      "spectacle"
      "the-unarchiver"
    ];
  };
}
