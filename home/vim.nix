{pkgs, ...}: let
  amixVimrc = "${pkgs.fetchFromGitHub {
    owner = "amix";
    repo = "vimrc";
    rev = "63419d6513fd10b42ad1fcc1ed80ca8c8c1508ec";
    hash = "sha256-mMoo4SEBhi8KlVH8ehwwKqGO3gAZuHjTtDwSc4c5vj4=";
  }}/vimrcs/basic.vim";
  vimConfig = ''
    source ${amixVimrc}
    colorscheme default
  '';
in {
  programs.vim = {
    enable = true;
    defaultEditor = true;
    # Home Manager wraps vim with `-u <generated vimrc>`, which skips
    # ~/.vimrc, so the Home Manager vim has to source the config itself.
    extraConfig = vimConfig;
  };

  # Still read by macOS's own /usr/bin/vim.
  home.file.".vimrc".text = vimConfig;
}
