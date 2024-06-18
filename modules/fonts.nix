{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      fira-code-nerdfont
      jetbrains-mono
      meslo-lgs-nf
      noto-fonts-cjk-sans
    ];
  };
}
