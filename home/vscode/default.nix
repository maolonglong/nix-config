{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    # package = pkgs.vscodium;
  };

  imports = [
    ./extensions.nix
    ./languages.nix
    ./settings.nix
    ./vim.nix
  ];
}
