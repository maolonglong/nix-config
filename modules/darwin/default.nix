{
  imports = [
    ./nix.nix
    ./users.nix
    ./packages.nix
    ./homebrew.nix
    ./fonts.nix
    ./security.nix
    ./system.nix
    ./secrets.nix
  ];

  system.stateVersion = 5;
}
