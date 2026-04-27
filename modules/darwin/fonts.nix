{
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs) mynur;
in {
  fonts.packages = with pkgs; [
    material-design-icons
    font-awesome

    source-sans
    source-serif
    source-han-sans
    source-han-serif

    nerd-fonts.symbols-only
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono

    meslo-lgs-nf
    noto-fonts-cjk-sans

    mynur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.jetbrains-maple-mono
  ];
}
