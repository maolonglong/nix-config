{pkgs, ...}: let
  amix-vimrc = pkgs.fetchFromGitHub {
    owner = "amix";
    repo = "vimrc";
    rev = "63419d6513fd10b42ad1fcc1ed80ca8c8c1508ec";
    hash = "sha256-mMoo4SEBhi8KlVH8ehwwKqGO3gAZuHjTtDwSc4c5vj4=";
  };
in {
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  home.file.".vimrc".source = "${amix-vimrc}/vimrcs/basic.vim";
}
