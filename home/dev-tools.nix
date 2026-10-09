{
  services.pueue.enable = true;

  # Language runtimes and agent CLIs, installed on demand by mise.
  programs.mise = {
    enable = true;
    package = null;
    # Brew-installed; tools resolve via the shims on PATH (home/path.nix).
    enableBashIntegration = false;
    enableZshIntegration = false;
    enableFishIntegration = false;
    enableNushellIntegration = false;
    globalConfig = {
      settings.minimum_release_age = "0s";
      tools = {
        bun = "latest";
        node = "24";
        "npm:@earendil-works/pi-coding-agent" = "latest";
        "npm:@openai/codex" = "latest";
        "npm:@agentclientprotocol/codex-acp" = "latest";
        "npm:agent-browser" = "latest";
        pnpm = "latest";
      };
    };
  };
}
