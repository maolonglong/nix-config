{
  imports = [
    ./packages.nix
    ./cli.nix
    ./dev-tools.nix
    ./ghostty.nix
    ./git.nix
    ./homebrew.nix
    ./lazygit.nix
    ./path.nix
    ./security.nix
    ./starship.nix
    ./tmux
    ./vim.nix
    ./xdg.nix
    ./zellij.nix
    ./zsh.nix
  ];

  # `home.username` and `home.homeDirectory` come from `users.users` through
  # the Home Manager nix-darwin module; see modules/darwin/users.nix.
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
