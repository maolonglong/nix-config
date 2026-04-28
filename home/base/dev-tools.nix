{pkgs, ...}: {
  home.packages = with pkgs; [
    commitizen
    scc
  ];

  # Node.js
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    globalConfig = {
      tools = {
        bun = "latest";
        node = "22";
        "npm:@github/copilot" = "latest";
        "npm:@mariozechner/pi-coding-agent" = "latest";
        "npm:@openai/codex" = "latest";
        "npm:agent-browser" = "latest";
        "npm:opencode-ai" = "latest";
        "npm:pnpm" = "latest";
      };
    };
  };
}
