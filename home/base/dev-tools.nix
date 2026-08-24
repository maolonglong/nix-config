{pkgs, ...}: {
  home.packages = with pkgs; [
    commitizen
    scc
  ];

  services.pueue.enable = true;

  # Node.js
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    globalConfig = {
      tools = {
        bun = "latest";
        node = "24";
        "npm:@earendil-works/pi-coding-agent" = "latest";
        "npm:@openai/codex" = "latest";
        "npm:@agentclientprotocol/codex-acp" = "latest";
        "npm:agent-browser" = "latest";
        "npm:opencode-ai" = "latest";
        "npm:@moonshot-ai/kimi-code" = "latest";
        "npm:pnpm" = "latest";
      };
    };
  };
}
