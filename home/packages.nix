{pkgs, ...}: {
  home.packages = with pkgs; [
    # Everyday CLI
    tldr
    cowsay
    glow
    fd
    (ripgrep.override {withPCRE2 = true;})
    just
    duf
    procs
    ast-grep

    # Build and measure
    gnumake
    hyperfine
    wrk
    scc
    commitizen

    # Containers and remote work
    mutagen
    mosh
    docker-client
    docker-credential-helpers
    cloudflared

    # Media
    ffmpeg-full
    imagemagick
    graphviz
  ];
}
