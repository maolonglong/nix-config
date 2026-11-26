{
  imports = [
    ./packages.nix
    ./cli.nix
    ./dev-tools.nix
    ./git.nix
    ./lazygit.nix
    ./path.nix
    ./security.nix
    ./starship.nix
    ./tmux
    ./vim.nix
    ./zellij.nix
    ./zsh.nix
    ./worktrunk.nix
  ];

  # On Darwin, `home.username` and `home.homeDirectory` come from `users.users`
  # through the Home Manager nix-darwin module (see modules/darwin/users.nix);
  # on Linux, `mkLinuxHome` sets them in flake.nix.
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
