{
  programs.zellij = {
    enable = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableZshIntegration = false;
    settings = {
      theme = "catppuccin-mocha";
      session_serialization = false;
    };
  };
}
