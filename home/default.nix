{myvars, ...}: {
  imports = [
    ./darwin/cloud.nix
    ./darwin/ghostty.nix
    ./darwin/homebrew.nix
    ./base/core.nix
    ./base/git.nix
    ./base/security.nix
    ./base/zsh.nix
    ./base/starship.nix
    ./base/zellij.nix
    ./base/tmux
    ./base/editors/vim.nix
    ./base/dev-tools.nix
    ./base/lazygit.nix
    ./base/media.nix
  ];

  home = {
    inherit (myvars) username;
    homeDirectory = "/Users/${myvars.username}";
    stateVersion = "26.05";
  };

  xdg = {
    enable = true;
    localBinInPath = true;
  };

  programs.home-manager.enable = true;
}
