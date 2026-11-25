{
  lib,
  pkgs,
  ...
}: {
  services.pueue.enable = true;

  # Language runtimes and agent CLIs, installed on demand by mise.
  programs.mise = {
    enable = true;
    package = lib.mkDefault (
      if pkgs.stdenv.hostPlatform.isDarwin
      then null
      else pkgs.mise
    );
    # Brew-installed on Darwin; tools resolve via the shims on PATH (home/path.nix).
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
