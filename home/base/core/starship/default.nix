{
  pkgs,
  inputs,
  ...
}: let
  inherit (inputs) mynur;
in {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings =
      {
        container.disabled = true;
        palette = "catppuccin_mocha";
      }
      // builtins.fromTOML (builtins.readFile "${mynur.legacyPackages.${pkgs.system}.catppuccinThemes.starship}/palettes/mocha.toml");
  };
}
