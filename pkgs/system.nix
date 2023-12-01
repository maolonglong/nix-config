{
  pkgs,
  inputs,
  vars,
  ...
}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    (with pkgs; [
      vim
      neovim
      bat
      coreutils
      eza
      fd
      fzf
      git
      htop
      jq
      lsof
      procs
      ripgrep
      tldr
      tmux
      tree
      unzip
      wget
      curl
      yq
      go
      tinygo
      lazygit
      delta
      duf
      jump
      direnv
      gnupg
      zig
      zls
      pueue
      age
      wrk
      mutagen
      neofetch
      socat
      rust-bin.stable.latest.default
      sccache
      rlwrap
      lima
      hyperfine
      alejandra
      nil
      commitizen
      graphviz
    ])
    ++ (with pkgs.nur.repos.maolonglong; [
      gosimports
      gofumpt
    ])
    ++ [
      inputs.ragenix.packages.${vars.arch}.default
    ];
}
