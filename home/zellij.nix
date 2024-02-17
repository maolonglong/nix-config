{pkgs, ...}: {
  programs.zellij = {
    enable = true;
    settings = {
      theme = "catppuccin-mocha";
      session_serialization = false;
    };
  };
}
