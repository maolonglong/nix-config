{pkgs, ...}: {
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      jetbrains-mono
      fira-code-nerdfont
      meslo-lgs-nf
      noto-fonts-cjk-sans
    ];
  };
}
