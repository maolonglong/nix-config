{pkgs, ...}: {
  home.packages = with pkgs; [
    ffmpeg-full
    imagemagick
    graphviz
  ];
}
