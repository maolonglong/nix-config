{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    git
    git-lfs

    zip
    xz
    zstd
    unzipNLS
    p7zip

    gnugrep
    gnused
    gawk
    jq

    mtr
    iperf3
    dnsutils
    ldns
    wget
    curl
    aria2
    socat
    nmap
    ipcalc

    file
    findutils
    which
    tree
    gnutar
    rsync

    htop
    neofetch

    rlwrap
  ];
}
