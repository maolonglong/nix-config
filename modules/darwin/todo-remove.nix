{
  pkgs,
  inputs,
  myvars,
  ...
}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    (with pkgs; [
      age
      alejandra
      bat
      # cachix
      commitizen
      coreutils
      curl
      delta
      direnv
      duf
      eza
      fd
      fzf
      git
      gnupg
      go
      graphviz
      htop
      hyperfine
      jq
      jump
      lazygit
      lima
      lsof
      mutagen
      neofetch
      neovim
      nil
      procs
      pueue
      ripgrep
      rlwrap
      # TODO: 看看有没有更好的方式，感觉还是 rustup 方便些
      # (rust-bin.stable.latest.default.override {extensions = ["rust-src"];})
      sccache
      socat
      # tinygo
      tldr
      tmux
      tree
      unzip
      vim
      wget
      wrk
      yq
      # TODO: 好像需要 override，后面再修
      # zig
      # zig-shell-completions
      # zls
      restic
      rclone
    ])
    ++ (with pkgs.nur.repos.maolonglong; [
      fx
      gofumpt
      gosimports
    ]);
}
