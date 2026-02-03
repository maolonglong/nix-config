{...}: {
  catppuccin.starship.enable = true;

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      container.disabled = true;
      docker_context.disabled = true;
    };
  };
}
