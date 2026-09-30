{
  catppuccin.starship.enable = true;

  programs.starship = {
    enable = true;
    settings = {
      container.disabled = true;
      docker_context.disabled = true;
    };
  };
}
