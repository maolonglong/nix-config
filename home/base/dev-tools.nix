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
        node = "24";
        "npm:@earendil-works/pi-coding-agent" = "latest";
        "npm:@openai/codex" = "latest";
        "npm:@zed-industries/codex-acp" = "latest";
        "npm:agent-browser" = "latest";
        "npm:opencode-ai" = "latest";
        "npm:pnpm" = "latest";
      };
    };
  };
}
