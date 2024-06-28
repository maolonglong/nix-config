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
      // builtins.fromTOML (builtins.readFile "${mynur.packages.${pkgs.system}.catppuccin-starship}/palettes/mocha.toml");
  };
}
