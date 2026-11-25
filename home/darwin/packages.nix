{pkgs, ...}: {
  home.packages = with pkgs; [
    # Media
    ffmpeg-full
    imagemagick
    graphviz
  ];
}
