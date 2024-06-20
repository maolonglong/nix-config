{
  programs.alacritty = {
    enable = true;
    # settings = builtins.fromTOML (builtins.readFile ./alacritty.toml);
  };

  xdg.configFile."alacritty/alacritty.toml".source = ./alacritty.toml;
}
