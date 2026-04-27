{
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs) mynur;
in {
  programs.alacritty.enable = false;

  xdg.configFile."alacritty/alacritty.toml".text =
    (builtins.readFile ./alacritty.toml)
    + (builtins.readFile "${mynur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.catppuccinThemes.alacritty}/catppuccin-mocha.toml");
}
