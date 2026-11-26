{
  services.pueue.enable = true;

  # Language runtimes and agent CLIs, installed on demand by mise.
  # Tools resolve via shims on PATH (`home/base/path.nix`); Darwin supplies the
  # binary via Homebrew (`home/darwin/homebrew.nix`).
  programs.mise = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
    enableFishIntegration = false;
    enableNushellIntegration = false;
    globalConfig = {
      tools = {
        bun = "1";
        node = "24";
        "npm:@earendil-works/pi-coding-agent" = "latest";
        "npm:@openai/codex" = "latest";
        "npm:@agentclientprotocol/codex-acp" = "latest";
        "npm:agent-browser" = "latest";
        pnpm = "12";
      };
    };
  };
}
