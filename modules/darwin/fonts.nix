{
  pkgs,
  inputs,
  ...
}: let
  inherit (inputs) mynur;
in {
  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-design-icons
      font-awesome

      # 思源系列字体是 Adobe 主导的。其中汉字部分被称为「思源黑体」和「思源宋体」，是由 Adobe + Google 共同开发的
      source-sans # 无衬线字体，不含汉字。字族名叫 Source Sans 3 和 Source Sans Pro，以及带字重的变体，加上 Source Sans 3 VF
      source-serif # 衬线字体，不含汉字。字族名叫 Source Code Pro，以及带字重的变体
      source-han-sans # 思源黑体
      source-han-serif # 思源宋体

      # nerdfonts
      # https://github.com/NixOS/nixpkgs/blob/nixos-25.11/pkgs/data/fonts/nerd-fonts/manifests/fonts.json
      nerd-fonts.symbols-only
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono

      # julia-mono
      # dejavu_fonts
      meslo-lgs-nf
      noto-fonts-cjk-sans

      # https://github.com/SpaceTimee/Fusion-JetBrainsMapleMono
      mynur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.jetbrains-maple-mono
    ];
  };
}
