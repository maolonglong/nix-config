{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs;
    [
      # Everyday CLI
      gh
      jq
      tldr
      cowsay
      glow
      fd
      (ripgrep.override {withPCRE2 = true;})
      just
      duf
      procs
      ast-grep
      tree
      htop
      fastfetch
      rlwrap

      # Archives
      zip
      xz
      zstd
      unzipNLS
      p7zip

      # Network and remote work
      mtr
      iperf3
      dnsutils
      ldns
      socat
      nmap
      ipcalc
      mutagen
      cloudflared

      # Build and measure
      gnumake
      hyperfine
      wrk
      scc
      commitizen
      prek
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Media
      ffmpeg-full
      imagemagick
      graphviz
    ];
}
