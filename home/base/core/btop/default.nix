{
  xdg.configFile."btop/themes/catppuccin_mocha.theme".source = ./catppuccin_mocha.theme;

  # replacement of htop/nmon
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "catppuccin_mocha";
      theme_background = false; # make btop transparent
    };
  };
}
