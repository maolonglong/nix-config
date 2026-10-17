{
  config,
  lib,
  ...
}: {
  catppuccin.starship.enable = true;

  # The catppuccin module reads the port at evaluation time (IFD), so nothing
  # in the generation references it and `nix-collect-garbage` deletes it.
  # Keeping it as an extra dependency avoids rebuilding it on the next switch.
  home.extraDependencies = lib.optional config.catppuccin.starship.enable config.catppuccin.sources.starship;

  programs.starship = {
    enable = true;
    settings = {
      container.disabled = true;
      docker_context.disabled = true;
    };
  };
}
