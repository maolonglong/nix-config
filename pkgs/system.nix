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
      (rust-bin.stable.latest.default.override {extensions = ["rust-src"];})
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
      zig
      zig-shell-completions
      zls
      restic
      rclone
    ])
    ++ (with pkgs.nur.repos.maolonglong; [
      fx
      gofumpt
      gosimports
    ])
    ++ [
      inputs.agenix.packages.${myvars.system}.default
    ];
}
