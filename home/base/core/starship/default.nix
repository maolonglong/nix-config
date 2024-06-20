{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings =
      {
        palette = "catppuccin_mocha";
      }
      // builtins.fromTOML (builtins.readFile ./catppuccin_mocha.toml);
  };
}
