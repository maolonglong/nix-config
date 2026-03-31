{
  pkgs,
  inputs,
  ...
}: let
  inherit (inputs) mynur;
in {
  programs.alacritty = {
    enable = false;
    # settings = builtins.fromTOML (builtins.readFile ./alacritty.toml);
  };

  xdg.configFile."alacritty/alacritty.toml".text =
    (builtins.readFile ./alacritty.toml)
    + (builtins.readFile "${mynur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.catppuccinThemes.alacritty}/catppuccin-mocha.toml");
}
