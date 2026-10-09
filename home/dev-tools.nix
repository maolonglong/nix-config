{
  services.pueue.enable = true;

  # Language runtimes and agent CLIs, installed on demand by mise.
  programs.mise = {
    enable = true;
    package = null;
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
