{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    package =
      if pkgs.stdenv.hostPlatform.isDarwin
      then null # installed via Homebrew cask on darwin
      else pkgs.ghostty;
    settings = {
      adjust-cell-height = 3;
      adjust-cell-width = -1;
      clipboard-paste-bracketed-safe = true;
      clipboard-paste-protection = true;
      clipboard-read = "ask";
      clipboard-write = "allow";
      copy-on-select = false;
      cursor-style = "block";
      cursor-style-blink = false;
      font-family = ["ComicShannsMono Nerd Font" "Hannotate SC"];
      font-feature = "feat";
      font-size = 16;
      font-thicken = true;
      keybind = "shift+enter=text:\\n";
      macos-option-as-alt = "left";
      macos-titlebar-proxy-icon = "hidden";
      macos-titlebar-style = "tabs";
      mouse-hide-while-typing = true;
      scrollback-limit = 10000000;
      selection-invert-fg-bg = true;
      shell-integration = "zsh";
      shell-integration-features = "sudo,no-cursor,ssh-terminfo,ssh-env";
      theme = "Catppuccin Mocha";
      unfocused-split-opacity = 0.85;
      window-decoration = true;
      window-padding-balance = true;
      window-padding-x = 8;
      window-padding-y = 6;
      window-theme = "dark";
    };
  };
}
