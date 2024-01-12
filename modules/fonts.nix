{pkgs, ...}: {
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      fira-code-nerdfont
      jetbrains-mono
      meslo-lgs-nf
      noto-fonts-cjk-sans
    ];
  };
}
