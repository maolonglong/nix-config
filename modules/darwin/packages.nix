{pkgs, ...}: {
  # Core system utilities only; interactive CLI tools live in `home/packages.nix`.
  # `git` and `git-lfs` stay here because `work-mbp` disables `programs.git`.
  environment.systemPackages = with pkgs; [
    git
    git-lfs

    gnugrep
    gnused
    gawk
    gnutar

    file
    findutils
    which
    rsync
  ];
}
