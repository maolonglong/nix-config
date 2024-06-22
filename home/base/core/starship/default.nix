{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings =
      {
        container.disabled = true;
        palette = "catppuccin_mocha";
      }
      // builtins.fromTOML (builtins.readFile ./catppuccin_mocha.toml);
  };
}
