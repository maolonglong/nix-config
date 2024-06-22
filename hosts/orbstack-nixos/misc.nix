{
  pkgs,
  myvars,
  ...
}: {
  programs.zsh.enable = true;
  environment.shells = [pkgs.zsh];
  users.users.${myvars.username}.shell = pkgs.zsh;
}
